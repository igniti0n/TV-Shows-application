import 'package:dio/dio.dart';

abstract class NetworkClient {
  Dio get client;
  void setInterceptorAuthHeader(String token);
  void removeInterceptorAuthHeader();
  Future<FormData> createFormDataFromFile(String filePath);
}

class NetworkClientImpl extends NetworkClient {
  final Dio _dio;

  NetworkClientImpl(this._dio);

  Dio get client => _dio;

  void setInterceptorAuthHeader(String token) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = token;
          return handler.next(options);
        },
      ),
    );
  }

  Future<FormData> createFormDataFromFile(String filePath) async {
    return FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: 'uploadfile',
      ),
    });
  }

  @override
  void removeInterceptorAuthHeader() {
    _dio.interceptors.removeLast();
  }
}
