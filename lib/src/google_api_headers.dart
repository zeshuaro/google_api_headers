import 'package:google_api_headers/src/my_platform.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/services.dart';

/// GoogleApiHeaders provide a method for getting the headers required for
/// calling Google APIs with a restricted key.
///
/// ```dart
/// import 'package/google_api_headers/google_api_headers.dart';
///
/// final headers = await GoogleApiHeaders().getHeaders();
/// ```
class GoogleApiHeaders {
  final MyPlatform platform;

  /// Constructor with an optional parameter of [MyPlatform].
  /// Default to [MyPlatformImp] if the parameter is not provided.
  const GoogleApiHeaders([MyPlatform platform])
      : platform = platform ?? const MyPlatformImp();

  static Map<String, String> _headers = {};
  final MethodChannel _channel = const MethodChannel('google_api_headers');

  /// Get the headers required for calling Google APIs with a restricted key
  /// based on the platform.
  Future<Map<String, String>> getHeaders() async {
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
