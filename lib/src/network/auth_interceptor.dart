import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tradeable_flutter_sdk/src/utils/security.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = TFS().token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      options.headers['x-axis-token'] = token;
      options.headers['x-axis-app-id'] = TFS().appId ?? '';
      options.headers['x-axis-client-id'] = TFS().clientId ?? '';
      options.headers['x-api-encryption-key'] = TFS().encryptionKey ?? '';
    }

    // if (TFS().encryptionKey != null &&
    //     (options.method == 'POST' ||
    //         options.method == 'PUT' ||
    //         options.method == 'PATCH')) {
    //   if (options.data != null) {
    //     try {
    //       final encryptedData = encryptData(options.data, TFS().encryptionKey!);
    //       options.data = {'encryptedData': encryptedData};
    //     } catch (e) {
    //       if (kDebugMode) {
    //         print('Failed to encrypt request body: $e');
    //       }
    //     }
    //   }
    // }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Notify TFS about token expiration
      await TFS().onTokenExpired();

      // Store the failed request for retry
      final requestOptions = err.requestOptions;

      // Wait for new token and retry
      _retryWithNewToken(requestOptions, handler);
      return;
    }
    super.onError(err, handler);
  }

  Future<void> _retryWithNewToken(
      RequestOptions requestOptions, ErrorInterceptorHandler handler) async {
    final newToken = TFS().token;
    if (newToken != null) {
      // Update the request with new token
      requestOptions.headers['Authorization'] = 'Bearer $newToken';
      requestOptions.headers['x-axis-token'] = newToken;
      requestOptions.headers['x-axis-app-id'] = TFS().appId ?? '';
      requestOptions.headers['x-axis-client-id'] = TFS().clientId ?? '';
      // requestOptions.headers['x-api-encryption-key'] =
      //     TFS().encryptionKey ?? '';

      // Retry the request
      try {
        final dio = Dio();
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(DioException(requestOptions: requestOptions, error: e));
      }
    } else {
      // No new token available, pass the original error
      handler.next(DioException(
          requestOptions: requestOptions,
          error: 'Token expired and no new token provided'));
    }
  }
}
