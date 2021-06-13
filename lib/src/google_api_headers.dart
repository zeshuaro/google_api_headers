import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_api_headers/src/my_platform.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// GoogleApiHeaders provide a method for getting the headers required for
/// calling Google APIs with a restricted key.
///
/// ```dart
/// import 'package:google_api_headers/google_api_headers.dart';
///
/// final headers = await GoogleApiHeaders().getHeaders();
/// ```
class GoogleApiHeaders {
  final MyPlatform platform;

  /// Constructor with an optional parameter of [MyPlatform].
  /// Default to [MyPlatformImp] if the parameter is not provided.
  const GoogleApiHeaders([MyPlatform? platform])
      : platform = platform ?? const MyPlatformImp();

  static Map<String, String> _headers = {};
  final MethodChannel _channel = const MethodChannel('google_api_headers');

  /// Clear cached headers.
  @visibleForTesting
  static void clear() => _headers.clear();

  /// Get the headers required for calling Google APIs with a restricted key
  /// based on the platform (iOS or Android). For web,
  /// an empty header will be returned.
  Future<Map<String, String>> getHeaders() async {
    if (_headers.isEmpty && !kIsWeb && !platform.isDesktop) {
      final packageInfo = await PackageInfo.fromPlatform();
      if (platform.isIos) {
        _headers = {
          "X-Ios-Bundle-Identifier": packageInfo.packageName,
        };
      } else if (platform.isAndroid) {
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
