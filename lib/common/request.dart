import 'package:dio/dio.dart';
import 'package:elephant_chat/common/consts.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "http://$HTTP_HOST",
  connectTimeout: 10000,
  receiveTimeout: 10000,
);

Dio request = Dio(options)
  ..interceptors.add(InterceptorsWrapper(onResponse: (Response response) async {
    if (!response.data['success']) {
      return request.reject('Dio请求错误: ${response.data['message']}');
    }
    return response.data['content'];
  }, onError: (DioError e) async {
    // Do something with response error
    print('Dio请求错误: ${e.message}');
    return e; //continue
  }));
