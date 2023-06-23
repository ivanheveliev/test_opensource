import 'dart:convert';
import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/data/models/response_error_api_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

class RequestsRepo {
  final Dio dio = Dio();

  Future<dynamic> checkUserHasInternet() async {
    dynamic result = true;
    await Connectivity().checkConnectivity().then(
      (value) {
        if (value.name == 'none') {
          result = DataErrorHelper(
            error: AppConfig.errorNoConnectionString,
            noConnection: true,
          );
        }
      },
    );
    return result;
  }

  dynamic catchError(String method, dynamic error) {
    if (error is DioError) {
      try {
        debugPrint(
            '${AppConfig.debugPrint} $method _catchError = ${error.response.toString().trim()}');
        return DataErrorHelper(
          error: ResponseErrorAPIModel.fromJson(
            json.decode(
              error.response.toString().trim(),
            ),
          ).message!,
          responseCode: error.response!.statusCode ?? 0,
        );
      } catch (newError) {
        debugPrint(
            '${AppConfig.debugPrint} $method _catchError newError = ${newError.toString()}');
        return DataErrorHelper(
          error: error.response.toString().trim(),
        );
      }
    } else {
      debugPrint(
          '${AppConfig.debugPrint} $method _catchError = ${error.toString()}');
      return DataErrorHelper(
        error: error.toString().trim(),
      );
    }
  }
}
