package io.github.zeshuaro.google_api_headers

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.content.pm.Signature
import android.os.Build // Import Build explicitly if needed
import androidx.annotation.UiThread
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.math.BigInteger
import java.security.MessageDigest

class GoogleApiHeadersPlugin : MethodCallHandler, FlutterPlugin {
    private var channel: MethodChannel? = null
    private var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "google_api_headers").apply {
            setMethodCallHandler(this@GoogleApiHeadersPlugin)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        context = null
    }

    @SuppressLint("PackageManagerGetSignatures")
    @UiThread
    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getSigningCertSha1") {
            try {
                // Consider safer handling than !! if context could theoretically be null here
                val packageManager = context!!.packageManager
                // Consider safer handling for arguments if they might be missing
                val args = call.arguments<String>()!!

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    // Use ?. safe call on signingInfo and apkContentsSigners
                    packageManager.getPackageInfo(
                        args,
                        PackageManager.GET_SIGNING_CERTIFICATES
                    ).signingInfo?.apkContentsSigners?.forEach { signature -> // <-- FIX 1: Added ?. twice
                        parseSignature(
                            signature,
                            result
                        )
                    }
                } else {
                    @Suppress("DEPRECATION")
                    // Use ?. safe call on signatures
                    packageManager.getPackageInfo(
                        args,
                        PackageManager.GET_SIGNATURES
                    ).signatures?.forEach { signature -> // <-- FIX 2: Added ?. here
                        parseSignature(signature, result)
                    }
                }
                // Note: If getPackageInfo finds no signers/signatures, this might succeed
                // without calling result.success(). Depending on desired behavior,
                // you might want to add a check here to call result.error() if no
                // signature was processed. This code currently relies on parseSignature
                // calling result.success().

            } catch (e: PackageManager.NameNotFoundException) {
                // Be more specific catching expected exceptions
                result.error("PACKAGE_NOT_FOUND", "Package '$args' not found.", null)
            } catch (e: Exception) {
                // Catch other potential exceptions
                result.error("ERROR", e.toString(), null)
            }
        } else {
            result.notImplemented()
        }
    }

    private fun parseSignature(signature: Signature, result: Result) {
        try {
            val md: MessageDigest = MessageDigest.getInstance("SHA1")
            md.update(signature.toByteArray())

            val bytes: ByteArray = md.digest()
            val bigInteger = BigInteger(1, bytes)
            val hex: String = String.format("%0" + (bytes.size shl 1) + "x", bigInteger)

            result.success(hex)
        } catch (e: Exception) {
            result.error("PARSE_ERROR", "Failed to parse signature: ${e.message}", null)
        }
    }
}
