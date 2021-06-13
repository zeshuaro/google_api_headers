import 'dart:io';

/// Abstract class for platform implementations.
abstract class MyPlatform {
  /// Returns if the platform is Android.
  bool get isAndroid;

  /// Returns if the platform is iOS.
  bool get isIos;

  /// Returns if the platform is desktop.
  bool get isDesktop;
}

/// MyPlatformImp implements the methods of whether the platform is
/// iOS or Android.
class MyPlatformImp implements MyPlatform {
  /// Const constructor.
  const MyPlatformImp();

  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isIos => Platform.isIOS;

  @override
  bool get isDesktop {
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }
}
