import 'dart:io';

abstract class MyPlatform {
  bool isAndroid();
  bool isIos();
}

class MyPlatformImp implements MyPlatform {
  @override
  bool isAndroid() => Platform.isAndroid;

  @override
  bool isIos() => Platform.isIOS;
}
