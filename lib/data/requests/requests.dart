import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:test_opensource/base/app_config.dart';
import 'package:test_opensource/base/app_methods.dart';
import 'package:test_opensource/data/data_error_helper/data_error_helper.dart';
import 'package:test_opensource/data/models/response_application_list_api_model.dart';
import 'package:test_opensource/data/models/response_category_list_api_model.dart';
import 'package:test_opensource/data/models/response_registration_api_model.dart';
import 'package:test_opensource/data/models/response_sign_in_api_model.dart';
import 'package:test_opensource/data/models/response_sign_in_code_api_model.dart';
import 'package:test_opensource/data/models/response_user_info_api_model.dart';
import 'package:test_opensource/data/requests/requests_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Requests extends RequestsRepo {
  Future<dynamic> createRequest({
    required String method,
    required String url,
    required FormData queryParameters,
    required headers,
    bool isGetMethod = true,
  }) async {
    try {
      debugPrint(
        '${AppConfig.debugPrint} START $method url = $url, queryParameters = ${queryParameters.fields}, headers = $headers',
      );
      dynamic checkInternet = await checkUserHasInternet();
      if (checkInternet is DataErrorHelper) return checkInternet;
      Response response;
      if (isGetMethod) {
        response = await dio.get(
          url,
          options: Options(
            headers: headers,
            responseType: ResponseType.plain,
          ),
        );
      } else {
        response = await dio.post(
          url,
          options: Options(
            headers: headers,
            responseType: ResponseType.plain,
          ),
          data: queryParameters,
        );
      }
      log(
        '${AppConfig.debugPrint} RESPONSE $method ${response.statusCode} = ${response.data}',
      );
      final Map<String, dynamic> dataFormatted = json.decode(
        response.data.toString().trim(),
      );
      return ResponseDataHelper(
        dynamicData: dataFormatted,
        dioResponse: response,
      );
    } catch (error) {
      return catchError(method, error);
    }
  }

  Future<dynamic> sendPhoneNumber({
    required String number,
  }) async {
    String method = 'sendPhoneNumber';
    String url = AppConfig.apiMainURL + AppConfig.apiSignInURL;
    final queryParameters = FormData.fromMap(
      {
        "phone": number,
      },
    );
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    dynamic result = await createRequest(
      method: method,
      url: url,
      queryParameters: queryParameters,
      headers: headers,
      isGetMethod: false,
    );
    if (result is ResponseDataHelper) {
      try {
        final data = ResponseSignInCodeAPIModel.fromJson(
          result.dynamicData,
        );
        return data;
      } catch (error) {
        return catchError(method, error);
      }
    } else {
      return result;
    }
  }

  Future<dynamic> sendSmsCode({
    required String number,
    required String code,
  }) async {
    String method = 'sendSmsCode';
    String url = AppConfig.apiMainURL + AppConfig.apiSignInURL;
    final queryParameters = FormData.fromMap(
      {
        "phone": number,
        "code": code,
      },
    );
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    dynamic result = await createRequest(
      method: method,
      url: url,
      queryParameters: queryParameters,
      headers: headers,
      isGetMethod: false,
    );
    if (result is ResponseDataHelper) {
      try {
        final data = ResponseRegistrationAPIModel.fromJson(result.dynamicData);
        return data;
      } catch (error) {
        return catchError(method, error);
      }
    } else {
      return result;
    }
  }

  Future<dynamic> registerUser({
    required String number,
    required String code,
    required String type,
    required String name,
  }) async {
    String method = 'registerUser';
    String url = AppConfig.apiMainURL + AppConfig.apiRegistrationURL;
    final queryParameters = FormData.fromMap(
      {
        "phone": number,
        "code": code,
        "type_user": type,
        "name": name,
      },
    );
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    dynamic result = await createRequest(
      method: method,
      url: url,
      queryParameters: queryParameters,
      headers: headers,
      isGetMethod: false,
    );
    if (result is ResponseDataHelper) {
      try {
        final data = ResponseRegistrationAPIModel.fromJson(result.dynamicData);
        return data;
      } catch (error) {
        return catchError(method, error);
      }
    } else {
      return result;
    }
  }

  Future<dynamic> getCategoryList() async {
    String method = 'getCategoryList';
    String url = AppConfig.apiMainURL + AppConfig.apiCategoryListURL;
    final queryParameters = FormData.fromMap(
      {},
    );
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    dynamic result = await createRequest(
      method: method,
      url: url,
      queryParameters: queryParameters,
      headers: headers,
    );
    if (result is ResponseDataHelper) {
      try {
        final data = ResponseCategoryListAPIModel.fromJson(result.dynamicData);
        return data;
      } catch (error) {
        return catchError(method, error);
      }
    } else {
      return result;
    }
  }

  Future<dynamic> sendApplication({
    required List<File> files,
    required String categoryId,
    required String descriptionProblem,
  }) async {
    String method = 'sendApplication';
    String url = AppConfig.apiMainURL + AppConfig.apiCreateApplicationURL;
    final queryParameters = FormData.fromMap(
      {
        "token": AppMethods().getUserToken(),
        "category_id": categoryId,
        "description": descriptionProblem,
      },
    );
    for (int i = 0; i < files.length; i++) {
      queryParameters.files.add(
          MapEntry(
            "image_$i",
            await MultipartFile.fromFile(
              files[i].path,
            ),
          ),
      );
    }
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    dynamic result = await createRequest(
      method: method,
      url: url,
      queryParameters: queryParameters,
      headers: headers,
      isGetMethod: false,
    );
    if (result is ResponseDataHelper) {
      try {
        final data = ResponseCategoryListAPIModel.fromJson(result.dynamicData);
        return data;
      } catch (error) {
        return catchError(method, error);
      }
    } else {
      return result;
    }
  }

  Future<dynamic> getApplicationList() async {
    String method = 'getApplicationList';
    String url = AppConfig.apiMainURL + AppConfig.apiApplicationsListURL;
    final queryParameters = FormData.fromMap(
      {
        "token": AppMethods().getUserToken(),
      },
    );
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    dynamic result = await createRequest(
      method: method,
      url: url,
      queryParameters: queryParameters,
      headers: headers,
      isGetMethod: false,
    );
    if (result is ResponseDataHelper) {
      try {
        final data = ResponseApplicationListAPIModel.fromJson(
          result.dynamicData,
        );
        return data;
      } catch (error) {
        return catchError(method, error);
      }
    } else {
      return result;
    }
  }

  Future<dynamic> getUserInfo() async {
    String method = 'getUserInfo';
    String url = AppConfig.apiMainURL + AppConfig.apiGetUserInfoURL;
    final queryParameters = FormData.fromMap(
      {
        "token": AppMethods().getUserToken(),
      },
    );
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    dynamic result = await createRequest(
      method: method,
      url: url,
      queryParameters: queryParameters,
      headers: headers,
      isGetMethod: false,
    );
    if (result is ResponseDataHelper) {
      try {
        final data = ResponseUserInfoAPIModel.fromJson(
          result.dynamicData,
        );
        return data;
      } catch (error) {
        return catchError(method, error);
      }
    } else {
      return result;
    }
  }
}
