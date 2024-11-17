// ignore_for_file: unused_import

import 'package:dio/dio.dart';
// import 'package:dio/native_imp.dart';
import 'package:kiind_web/core/constants/env_keys.dart';
import 'package:kiind_web/core/util/extensions/string_extensions.dart';
import 'package:kiind_web/core/util/rest/interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// class RestClient extends Dio {
//   RestClient() : super() {
//     options = BaseOptions(baseUrl: kBaseUrl.env);

//     // options?.connectTimeout = Constants.requestTimeout.inSeconds;
//     interceptors.add(
//       RestInterceptor()..initializeInterceptor(),
//     );

//     interceptors.add(
//       PrettyDioLogger(
//         requestHeader: false,
//         requestBody: true,
//       ),
//     );
//   }

//   refresh() {
//     // clear interceptors
//     interceptors.clear();

//     // add them again
//     interceptors.add(
//       RestInterceptor()..initializeInterceptor(),
//     );

//     interceptors.add(
//       PrettyDioLogger(
//         requestHeader: false,
//         requestBody: false,
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart'; // Import RestInterceptor

class RestClient {
  final Dio dio;

  RestClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: kBaseUrl.env,

            // connectTimeout: Constants.requestTimeout.inSeconds * 1000, // Uncomment if needed
          ),
        ) {
    _initializeInterceptors();
  }

  Future<void> _initializeInterceptors() async {
    // Use the factory constructor to initialize the interceptor
    final interceptor =
        await RestInterceptor.create(); // Use the factory constructor here
    dio.interceptors.add(interceptor);

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
      ),
    );
  }

  void refresh() {
    // Clear and re-add interceptors
    dio.interceptors.clear();
    _initializeInterceptors(); // Reinitialize interceptors
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    Options? options,
  }) {
    return dio.post(
      path,
      data: data,
      options: options,
    );
  }

  // You can add more methods like `put`, `delete`, etc., following the same pattern
}
