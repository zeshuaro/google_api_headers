package io.github.zeshuaro.google_api_headers

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.Signature
import androidx.annotation.UiThread
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.FlutterPlugin
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

    fun parseSignature(signature: Signature, result: Result) {
        val md: MessageDigest = MessageDigest.getInstance("SHA1")
        md.update(signature.toByteArray())

        val bytes: ByteArray = md.digest()
        val bigInteger = BigInteger(1, bytes)
        val hex: String = String.format("%0" + (bytes.size shl 1) + "x", bigInteger)

        result.success(hex)
    }

    @SuppressLint("PackageManagerGetSignatures")
    @UiThread
    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getSigningCertSha1") {
            try {
                val info: PackageInfo
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                    info = context!!.packageManager.getPackageInfo(call.arguments<String>() as String, PackageManager.GET_SIGNING_CERTIFICATES)
                    for (signature in info.signingInfo.apkContentsSigners) {
                        parseSignature(signature, result)
                    }
                } else {
                    @Suppress("DEPRECATION")
                    info = context!!.packageManager.getPackageInfo(call.arguments<String>() as String, PackageManager.GET_SIGNATURES)
                    @Suppress("DEPRECATION")
                    for (signature in info.signatures) {
                        parseSignature(signature, result)
                    }
                }

            } catch (e: Exception) {
                result.error("ERROR", e.toString(), null)
            }
        } else {
            result.notImplemented()
        }
    }
}