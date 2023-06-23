import 'dart:io';
import 'package:test_opensource/base/app_text_styles.dart';
import 'package:test_opensource/base/app_widgets.dart';
import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/data/models/response_user_info_api_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:test_opensource/base/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class AppMethods {
  getPreferences() async {
    AppConfig.sharedPreferences = await SharedPreferences.getInstance();
  }

  getPackageInfo() async {
    AppConfig.packageInfo = await PackageInfo.fromPlatform();
  }

  bool getBoolFromSP(String key) {
    try {
      bool result = AppConfig.sharedPreferences.getBool(key)!;
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<File?> getFileFromSource({bool fromCamera = false}) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      // return Image.file(File(pickedFile!.path));
      return File(pickedFile!.path);
    } catch (e) {
      return null;
    }
  }

  Future<void> getLogoutMethod() async {
    AppConfig.applicationList = [];
    AppConfig.userModel = ResponseUserInfoAPIModel();
    await AppConfig.sharedPreferences.remove(
      AppConfig.keyUserToken,
    );
  }

  Future<void> getLoginMethod({
    required String token,
  }) async {
    await AppConfig.sharedPreferences.setString(
      AppConfig.keyUserToken,
      token,
    );
  }

  void getUnFocusTextFieldMethod() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void showAlert({
    DataErrorHelper? error,
    String text = "",
    required BuildContext context,
  }) {
    String alertText = error == null
        ? text
        : error.noConnection
            ? AppConfig.errorNoConnectionString
            : "${AppConfig.errorOccurred} ${error.error.toString().trim()}";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppWidgets().getAppLabelWithPadding(
          text: alertText,
          style: AppTextStyles().getAppTextThemeHeadline9(),
        ),
      ),
    );
  }

  String getUserToken() {
    String? userToken = AppConfig.sharedPreferences.getString(
      AppConfig.keyUserToken,
    );
    return userToken ?? '';
  }

  Future<void> openPhone({
    required String phone,
    required BuildContext context,
  }) async {
    Uri url = Uri(
      scheme: "tel",
      path: phone,
    );
    try {
      await launchUrl(url);
    } catch (e) {
      debugPrint(
        '${AppConfig.debugPrint} ${e.toString()}',
      );
      showAlert(
        context: context,
        text: e.toString(),
      );
    }
  }
}
