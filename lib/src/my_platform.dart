import 'dart:io';

/// Abstract class for platform implementations.
abstract class MyPlatform {
  /// Returns whether the platform is Android or not.
  bool isAndroid();

  /// Returns whether the platform is iOS or not.
  bool isIos();
}

/// MyPlatformImp implements the methods of whether the platform is
/// iOS or Android.
class MyPlatformImp implements MyPlatform {
  /// Const constructor.
  const MyPlatformImp();

  @override
  bool isAndroid() => Platform.isAndroid;

  @override
  bool isIos() => Platform.isIOS;
}
