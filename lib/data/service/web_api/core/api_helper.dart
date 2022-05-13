import 'dart:convert';
import 'dart:io';

import 'package:emed/shared/setting/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const Map<String, String> defaultHeader = {
  HttpHeaders.contentTypeHeader: "application/json",
  HttpHeaders.acceptHeader: "application/json"
};

const defaultTimeOut = Duration(seconds: 15);

class ApiHelper {
  factory ApiHelper() {
    if (_instance == null) _instance = ApiHelper._getInstance();
    return _instance;
  }

  // Singleton 
  static ApiHelper _instance;

  ApiHelper._getInstance();

  String action;
  var client = http.Client();

  Future<APIResult> post({
    @required String action,
    Map<String, String> headers = defaultHeader,
    @required dynamic body,
  }) async {
    String baseUrl = CONFIG_BASE_URL;
    return client
        .post(
          baseUrl + "/" + action,
          headers: headers,
          body: body,
        )
        .timeout(defaultTimeOut)
        .then((response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        return APISuccess(data: jsonDecode(response.body));
      } else {
        return APIError(type: ErrorType.serverError, statusCode: statusCode);
      }
    }).catchError((err) {
      print("services error " + err.toString() + " - " + action);
      return APIError(type: ErrorType.unknownError, statusCode: -1);
    });
  }

  Future<APIResult> get(String action,
      {Map<String, String> headers = defaultHeader}) async {
    String baseUrl = CONFIG_BASE_URL;
    return client
        .get(
      baseUrl + "/" + action,
      headers: defaultHeader,
    )
        .then((response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        return APISuccess(data: json.decode(response.body));
      } else {
        return APIError(type: ErrorType.serverError, statusCode: statusCode);
      }
    }).catchError((err) {
      print("services error " + err.toString() + " - " + action);
      return APIError(type: ErrorType.unknownError, statusCode: -1);
    });
  }
}

enum ErrorType { serverError, unknownError }

class APIResult {
  APIResult([List props = const []]) : super();

  @override
  String toString() {
    return 'AppServiceResult';
  }
}

class APISuccess extends APIResult {
  final Map<String, dynamic> data;

  APISuccess({this.data}) : super([data]);

  @override
  String toString() {
    return 'APISuccess + $data';
  }
}

class APIError extends APIResult {
  final ErrorType type;
  final int statusCode;

  APIError({this.type, this.statusCode}) : super([type, statusCode]);

  @override
  String toString() {
    return 'APIError - error type: ${type.toString()} - status code: $statusCode';
  }
}
