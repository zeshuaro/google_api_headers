import 'dart:io';

/// Abstract class for platform implementations.
abstract class MyPlatform {
  /// Abstract const constructor.
  const MyPlatform();

  /// Returns whether the platform is Android or not.
  bool isAndroid();

  /// Returns whether the platform is iOS or not.
  bool isIos();
}

/// MyPlatformImp implements the methods of whether the platform is
/// iOS or Android.
class MyPlatformImp implements MyPlatform {
  const MyPlatformImp();

  @override
  bool isAndroid() => Platform.isAndroid;

  @override
  bool isIos() => Platform.isIOS;
}
