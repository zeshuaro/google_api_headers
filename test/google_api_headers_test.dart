import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MockMyPlatform extends Mock implements MyPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const packageName = 'io.github.zeshuaro.googleApiHeadersExample';
  const sha1 = 'sha1';
  const googleApiHeadersChannel = MethodChannel('google_api_headers');

  final platform = MockMyPlatform();
  late List<MethodCall> log;

  PackageInfo.setMockInitialValues(
    appName: 'google_api_headers_example',
    packageName: packageName,
    version: '1.0',
    buildNumber: '1',
    buildSignature: 'signature',
    installerStore: null,
  );

  setUp(() {
    log = <MethodCall>[];
    GoogleApiHeaders.clear();

    when(() => platform.isIos).thenReturn(false);
    when(() => platform.isAndroid).thenReturn(false);
    when(() => platform.isDesktop).thenReturn(false);
  });

  group('testGetGoogleApiHeaders', () {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      googleApiHeadersChannel,
      (message) async {
        log.add(message);
        switch (message.method) {
          case 'getSigningCertSha1':
            return sha1;
          default:
            assert(false);
            return null;
        }
      },
    );

    test('testGetHeadersOniOS', () async {
      when(() => platform.isIos).thenReturn(true);
      final headers = await GoogleApiHeaders(platform).getHeaders();
      expect(headers, {'X-Ios-Bundle-Identifier': packageName});
    });

    test('testGetHeadersOnAndroid', () async {
      when(() => platform.isAndroid).thenReturn(true);
      final headers = await GoogleApiHeaders(platform).getHeaders();
      expect(headers, {
        'X-Android-Package': packageName,
        'X-Android-Cert': sha1,
      });
    });

    test('testGetHeadersOnDesktop', () async {
      when(() => platform.isDesktop).thenReturn(true);
      final headers = await GoogleApiHeaders(platform).getHeaders();
      expect(headers, {});
    });

    test('testGetHeadersOnOtherPlatforms', () async {
      final headers = await GoogleApiHeaders(platform).getHeaders();
      expect(headers, {});
    });

    test('testGetHeadersOnDefaultPlatform', () async {
      final headers = await GoogleApiHeaders().getHeaders();
      expect(headers, {});
    });
  });

  test('testGetShaFailed', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      googleApiHeadersChannel,
      (message) async {
        log.add(message);
        switch (message.method) {
          case 'getSigningCertSha1':
            throw PlatformException(code: 'Not implemented');
          default:
            assert(false);
            return null;
        }
      },
    );

    when(() => platform.isAndroid).thenReturn(true);
    final headers = await GoogleApiHeaders(platform).getHeaders();
    expect(headers, {});
  });
}
