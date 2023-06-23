import 'package:dio/dio.dart';

class DataErrorHelper {
  final String error;
  final bool noConnection;
  final bool incorrectToken;
  final String? responseError;
  final int responseCode;

  DataErrorHelper({
    required this.error,
    this.noConnection = false,
    this.incorrectToken = false,
    this.responseError,
    this.responseCode = 0,
  });
}

class ResponseDataHelper {
  final dynamic dynamicData;
  final Response dioResponse;

  ResponseDataHelper({
    required this.dynamicData,
    required this.dioResponse,
  });
}
