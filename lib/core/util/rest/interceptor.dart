import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kiind_web/core/constants/box_keys.dart';
import 'package:kiind_web/core/constants/db_keys.dart';
import 'package:kiind_web/core/constants/endpoints.dart';
import 'package:kiind_web/core/util/extensions/response_extensions.dart';
import 'package:kiind_web/core/util/visual_alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RestInterceptor extends Interceptor {
  late Box prefBox;
  late SharedPreferences prefs;
  String? locale;
  String? token;

  RestInterceptor._(); // Private constructor for internal use

  // Factory constructor to initialize prefBox asynchronously
  static Future<RestInterceptor> create() async {
    final interceptor = RestInterceptor._();
    await interceptor.initializeInterceptor();
    return interceptor;
  }

  Future<void> initializeInterceptor() async {
    prefBox = await Hive.openBox(kPrefBox);
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    _updateToken();
  }

  void _updateToken({String? newToken}) {
    if (newToken == null) {
      if (prefBox.containsKey(DbKeys.authToken)) {
        token = prefBox.get(DbKeys.authToken);
      }
    } else {
      prefBox.put(DbKeys.authToken, newToken);
      token = newToken;
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    print("authentication token ::: $token");
    if (token?.isEmpty ?? true) _updateToken();

    if (token?.isNotEmpty ?? false) {
      options.headers['Authorization'] = 'Bearer $token';
      options.headers['Accept'] = 'application/json';
    } else if (!Endpoints.openEndpoints.containsKey(options.path)) {
      options.path = options.path;
    }

    // Add CSRF token for web requests (for POST, PUT, PATCH, DELETE)
    if (options.method.toUpperCase() != 'GET') {
      // Try to get CSRF token from meta tag in HTML document
      try {
        final csrfToken = html.document.querySelector('meta[name="csrf-token"]');
        if (csrfToken != null) {
          final tokenValue = csrfToken.getAttribute('content');
          if (tokenValue != null && tokenValue.isNotEmpty) {
            options.headers['X-CSRF-TOKEN'] = tokenValue;
          }
        }
      } catch (e) {
        // If we can't access the document (in some environments), continue without CSRF token
        print('Could not access CSRF token from HTML document: $e');
      }

      // Also try to get CSRF token from cookies (common in Laravel apps)
      try {
        final cookies = html.document.cookie;
        if (cookies != null) {
          final cookiePairs = cookies.split(';');
          for (final pair in cookiePairs) {
            final parts = pair.trim().split('=');
            if (parts.length == 2 && parts[0] == 'XSRF-TOKEN') {
              // Decode the cookie value if it's URL-encoded
              final csrfToken = Uri.decodeComponent(parts[1]);
              options.headers['X-XSRF-TOKEN'] = csrfToken;
              break;
            }
          }
        }
      } catch (e) {
        print('Could not access CSRF token from cookies: $e');
      }
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.hasToken) _updateToken(newToken: response.token);

    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    BuildContext? ctx = err.requestOptions.extra['context'];
    print(err);

    if (ctx != null) {
      try {
        showAlertFlash(ctx, 'Oops! An error occurred.');
      } catch (e) {
        showAlertToast('Oops! An error occurred.');
      }

      if (err.response != null && err.response!.statusCode == 401) {
        await clearUserCache();
      }
    }

    return handler.resolve(
      err.response ??
          Response(
            requestOptions: err.requestOptions,
            statusCode: err.response?.statusCode,
          ),
    );
  }
}

Future clearUserCache() async {
  final prefBox = await Hive.openBox(kPrefBox);

  await prefBox.delete(DbKeys.authToken);
  prefBox.delete(DbKeys.userData);
}
