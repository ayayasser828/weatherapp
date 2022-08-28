
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../constant/endpoints.dart';
import '../constant/global_variables.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseURL,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json'
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<dynamic, dynamic> data,
    String? token,
  }) async {
    debugPrint(data.toString());
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return dio.post(
      url,
      queryParameters: query,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            print("status code here${status}");
            return status! < 500;
          }),
    );
  }
}


