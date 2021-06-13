import 'package:flutter_test/flutter_test.dart';
import 'package:google_api_headers/google_api_headers.dart';

void main() {
  final platform = MyPlatformImp();
  test('testIsIos', () {
    expect(platform.isIos, false);
  });

  test('testIsAndroid', () {
    expect(platform.isAndroid, false);
  });

  test('testIsDesktop', () {
    expect(platform.isDesktop, true);
  });
}
