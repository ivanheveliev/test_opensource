import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_opensource/base/app_config.dart';
import 'dart:io';

class AppConstants {
  static double deviceStatusBarHeight =
      (window.padding.top / window.devicePixelRatio);
  static double deviceBottomTrash =
      (window.padding.bottom / window.devicePixelRatio);
  static double appHeight = Get.height;
  static double appWidth = Get.width;
  static double appSafeAreaHeight = appHeight -
      deviceStatusBarHeight -
      deviceBottomTrash -
      AppConfig.appBarHeight;
  static double appSafeAreaWithAppBarHeight =
      appHeight - deviceStatusBarHeight - deviceBottomTrash;
  static double appSafeAreaWithBottomTrash =
      appHeight - deviceStatusBarHeight - AppConfig.appBarHeight;
  static double appSafeAreaWithoutAppBarBottomNavigationBar = appHeight -
      deviceStatusBarHeight -
      AppConfig.appBarHeight -
      AppConfig.appBottomNavigationBarHeight -
      deviceBottomTrash;
  static bool isAndroid = Platform.isAndroid;
}
