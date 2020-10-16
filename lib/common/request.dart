import 'dart:developer';

import 'package:dio/dio.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "https://mocks.alibaba-inc.com/mock/daxiang-test",
  connectTimeout: 60000,
  receiveTimeout: 60000,
);

Dio request = Dio(options)
  ..interceptors.add(InterceptorsWrapper(onResponse: (Response response) async {
    if (!response.data['success']) {
      return request.reject('Dio Request error: ${response.data['message']}');
    }
    return response.data['data'];
  }, onError: (DioError e) async {
    // Do something with response error
    print('Dio request error: ${e.message}');
    return e; //continue
  }));
