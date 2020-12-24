import 'package:google_api_headers/src/my_platform.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/services.dart';

class GoogleApiHeaders {
  final MyPlatform platform;

  GoogleApiHeaders([MyPlatform platform])
      : platform = platform ?? MyPlatformImp();

  static Map<String, String> _headers = {};
  final MethodChannel _channel = const MethodChannel('google_api_headers');

  Future<Map<String, dynamic>> getHeaders() async {
    if (_headers.isEmpty) {
      final packageInfo = await PackageInfo.fromPlatform();
      if (platform.isIos()) {
        _headers = {
          "X-Ios-Bundle-Identifier": packageInfo.packageName,
        };
      } else if (platform.isAndroid()) {
        try {
          final sha1 = await _channel.invokeMethod(
            'getSigningCertSha1',
            packageInfo.packageName,
          );
          _headers = {
            "X-Android-Package": packageInfo.packageName,
            "X-Android-Cert": sha1,
          };
        } on PlatformException {
          _headers = {};
        }
      }
    }

    return _headers;
  }
}
