import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  final Dio _dio = Dio();

  ApiProvider() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      _dio.options.headers['Accept'] = 'application/json';
    }
  }

  Future<Response> getRequest(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> postRequest(String path,
      {Map<String, dynamic>? data}) async {
    return _dio.post(path, data: data);
  }

  Future<Response> putRequest(String path, {Map<String, dynamic>? data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> deleteRequest(String path) async {
    return _dio.delete(path);
  }

  void updateToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
    _dio.options.headers['Authorization'] = 'Bearer $newToken';
  }
}
