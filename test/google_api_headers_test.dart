import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'google_api_headers_test.mocks.dart';

@GenerateMocks([MyPlatform])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String packageName = 'io.github.zeshuaro.googleApiHeadersExample';
  const String sha1 = 'sha1';

  const MethodChannel packageInfoChannel = MethodChannel(
    'plugins.flutter.io/package_info',
  );
  const MethodChannel googleApiHeadersChannel = MethodChannel(
    'google_api_headers',
  );

  final platform = MockMyPlatform();
  late List<MethodCall> log;

  packageInfoChannel.setMockMethodCallHandler((MethodCall methodCall) async {
    log.add(methodCall);
    switch (methodCall.method) {
      case 'getAll':
        return <String, dynamic>{
          'appName': 'google_api_headers_example',
          'buildNumber': '1',
          'packageName': packageName,
          'version': '1.0',
        };
      default:
        assert(false);
        return null;
    }
  });

  setUp(() {
    log = <MethodCall>[];
    GoogleApiHeaders.clear();
  });

  group('testGetGoogleApiHeaders', () {
    googleApiHeadersChannel.setMockMethodCallHandler(
      (MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getSigningCertSha1':
            return sha1;
          default:
            assert(false);
            return null;
        }
      },
    );

    test('testGetHeadersOniOS', () async {
      when(platform.isIos()).thenReturn(true);
      when(platform.isAndroid()).thenReturn(false);
      final headers = await GoogleApiHeaders(platform).getHeaders();
      expect(headers, {'X-Ios-Bundle-Identifier': packageName});
    });

    test('testGetHeadersOnAndroid', () async {
      when(platform.isIos()).thenReturn(false);
      when(platform.isAndroid()).thenReturn(true);
      final headers = await GoogleApiHeaders(platform).getHeaders();
      expect(headers, {
        'X-Android-Package': packageName,
        'X-Android-Cert': sha1,
      });
    });

    test('testGetHeadersOnOthers', () async {
      when(platform.isIos()).thenReturn(false);
      when(platform.isAndroid()).thenReturn(false);
      final headers = await GoogleApiHeaders(platform).getHeaders();
      expect(headers, {});
    });

    test('testGetHeadersOnDefaultPlatform', () async {
      final headers = await GoogleApiHeaders().getHeaders();
      expect(headers, {});
    });
  });

  group('testGetHeadersErrors', () {
    test('testGetShaFailed', () async {
      googleApiHeadersChannel.setMockMethodCallHandler(
        (MethodCall methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'getSigningCertSha1':
              throw PlatformException(code: 'Not implemented');
            default:
              assert(false);
              return null;
          }
        },
      );

      when(platform.isIos()).thenReturn(false);
      when(platform.isAndroid()).thenReturn(true);
      final headers = await GoogleApiHeaders(platform).getHeaders();
      expect(headers, {});
    });
  });
}
