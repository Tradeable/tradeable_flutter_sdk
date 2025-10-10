import 'dart:developer';
import 'dart:math' hide log;

import 'package:dio/dio.dart';
import 'package:tradeable_flutter_sdk/src/utils/security.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = TFS().token;
    if (token != null) {
      options.headers['Authorization'] = TFS().authorization ?? '';
      options.headers['x-api-client-id'] = TFS().appId ?? '';
      options.headers['x-subAccountID'] = TFS().clientId ?? '';
      options.headers['x-authtoken'] = 'Bearer $token';
      options.headers['x-api-encryption-key'] = TFS().encryptionKey ?? '';
      options.headers['x-axis-token'] = token;
      options.headers['x-axis-app-id'] = TFS().appId ?? '';
      options.headers['x-axis-client-id'] = TFS().clientId ?? '';
      options.headers['Content-Type'] = 'application/json';
      options.headers['Accept'] = 'application/json';
    }

    if (TFS().encryptionKey != null &&
        (options.method == 'POST' ||
            options.method == 'PUT' ||
            options.method == 'PATCH')) {
      if (options.data != null) {
        try {
          log(options.data.toString());
          String encryptedData =
              encryptData(options.data, TFS().encryptionKey!);
          options.data = {'payload': encryptedData};
          log('Encrypted request body: $encryptedData');
        } catch (e) {
          log('Failed to encrypt request body: $e');
        }
      }
    }
    log('1 ===> ${options.baseUrl}${options.path}', name: "Auth Interceptor");
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log(err.response?.toString() ?? "null body", name: "Auth Interceptor");
    if (err.response?.statusCode == 401 ||
        err.response?.statusCode == 403 ||
        err.response?.statusCode == 400) {
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
    if (TFS().token != null) {
      // Update the request with new token
      String tokenAES = encryptData(TFS().token!, TFS().encryptionKey!);
      String tokenRSA = encryptRsa(TFS().token!, TFS().encryptionKey!);
      String authorizationRsa =
          encryptRsa(TFS().authorization!, TFS().encryptionKey!);
      String authorizationAes =
          encryptData(TFS().authorization, TFS().encryptionKey!);
      requestOptions.headers['Authorization'] = TFS().authorization ?? '';
      requestOptions.headers['x-api-client-id'] = TFS().appId ?? '';
      requestOptions.headers['x-subAccountID'] = TFS().clientId ?? '';
      requestOptions.headers['x-authtoken'] = tokenAES;
      requestOptions.headers['x-api-encryption-key'] =
          TFS().encryptionKey ?? '';
      requestOptions.headers['x-axis-token'] = TFS().token ?? '';
      requestOptions.headers['x-axis-app-id'] = TFS().appId ?? '';
      requestOptions.headers['x-axis-client-id'] = TFS().clientId ?? '';
      requestOptions.headers['Content-Type'] = 'application/json';
      requestOptions.headers['Accept'] = 'application/json';

      // Retry the request
      try {
        final dio = Dio();
        log('2 ===> ${requestOptions.baseUrl}${requestOptions.path}',
            name: "Auth Interceptor");
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);
      } catch (e) {
        log((e as DioException).response.toString(), name: "Auth Interceptor");
        handler.next(DioException(requestOptions: requestOptions, error: e));
      }
    } else {
      // No new token available, pass the original error
      // handler.next(DioException(
      //     requestOptions: requestOptions,
      //     error: 'Token expired and no new token provided'));
    }
  }
}
