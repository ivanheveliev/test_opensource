import 'package:test_opensource/base/app_assets.dart';
import 'package:test_opensource/base/app_classes.dart';
import 'package:test_opensource/base/app_constants.dart';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/data/models/response_application_list_api_model.dart';
import 'package:test_opensource/data/models/response_user_info_api_model.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  //project configuration___________________________
  static const String projectTitle = 'Test OpenSource';
  static const String debugPrint = 'DEBUG PRINT:';
  static const String debugPrintError = 'DEBUG PRINT ERROR:';

  //widgets___________________________
  static double appBarHeight = 64;
  static double appBottomNavigationBarHeight = 50;
  static double appBarLogoHeight = 30;

  //strings___________________________
  static const String errorNoConnectionString = 'Нет подключения к интернету';
  static const String errorOccurred = 'Произошла ошибка:';

  //storage___________________________
  static late SharedPreferences sharedPreferences;
  static PackageInfo? packageInfo;

  //urls___________________________
  static const String apiMainURL = 'http://data-deleted';
  static const String apiSignInURL = "/api/data-deleted/";
  static const String apiRegistrationURL = "/api/data-deleted/";
  static const String apiApplicationsListURL = "/api/data-deleted/";
  static const String apiCategoryListURL = "/api/data-deleted/";
  static const String apiCreateApplicationURL = "/api/data-deleted/";
  static const String apiGetUserInfoURL = "/api/data-deleted/";

  //patterns___________________________
  static Map<RegExp, TextStyle> numberPatternMap = {
    RegExp(r"^\w{3}"): AppTextStyles().getAppTextThemeHeadline2(),
  };

  //keys___________________________
  static const String keyClient = 'client';
  static const String keyMaster = 'master';
  static const String keyUserToken = 'userTokenKey';

  //data___________________________
  static List<Application> applicationList = [];
  static ResponseUserInfoAPIModel userModel = ResponseUserInfoAPIModel();
}
