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

            // 1. Declare and retrieve 'args' *before* the try block
            val args: String? = try {
                call.arguments<String>()
            } catch (e: Exception) {
                result.error("ARGUMENT_ERROR", "Failed to retrieve package name argument: ${e.message}", null)
                return // Exit if arguments cannot be retrieved
            }

            // 2. Validate arguments (optional but recommended)
            if (args.isNullOrEmpty()) {
                 result.error("ARGUMENT_ERROR", "Package name argument is missing or empty", null)
                 return // Exit if arguments are invalid
            }

            // 3. Now start the main try block - 'args' is accessible throughout
            try {
                // Consider safer context access -> context?.packageManager ?: throw IllegalStateException("Context is null")
                val packageManager = context!!.packageManager

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    packageManager.getPackageInfo(
                        args, // Now accessible
                        PackageManager.GET_SIGNING_CERTIFICATES
                    ).signingInfo?.apkContentsSigners?.forEach { signature ->
                        parseSignature(
                            signature,
                            result
                        )
                    }
                } else {
                    @Suppress("DEPRECATION")
                    packageManager.getPackageInfo(
                        args, // Now accessible
                        PackageManager.GET_SIGNATURES
                    ).signatures?.forEach { signature ->
                        parseSignature(signature, result)
                    }
                }
                // Note: Add check here if result.success() was potentially not called

            } catch (e: PackageManager.NameNotFoundException) {
                 // 'args' is now in scope and accessible here
                 result.error("PACKAGE_NOT_FOUND", "Package '$args' not found.", null)
            } catch (e: Exception) {
                 // General error - provide more specific message if possible
                 result.error("ERROR", "An unexpected error occurred: ${e.message}", null)
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
