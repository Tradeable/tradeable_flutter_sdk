import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tradeable_flutter_sdk/src/utils/security.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final portalToken = TFS().portalToken;
    if (portalToken != null) {
      options.headers['Authorization'] = TFS().authorization ?? '';
      options.headers['x-api-client-id'] = TFS().appId ?? '';
      options.headers['x-subAccountID'] = TFS().clientId ?? '';
      options.headers['x-aslToken'] = TFS().portalToken ?? '';
      options.headers['x-api-encryption-key'] =
          encryptRsa(TFS().secretKey ?? "", TFS().publicKey ?? "");
      options.headers['x-axis-token'] = TFS().portalToken ?? '';
      options.headers['x-axis-app-id'] = TFS().appId ?? '';
      options.headers['x-axis-client-id'] = TFS().clientId ?? '';
      options.headers['Content-Type'] = 'application/json';
      options.headers['Accept'] = 'application/json';
    }

    if (TFS().publicKey != null &&
        (options.method == 'POST' ||
            options.method == 'PUT' ||
            options.method == 'PATCH')) {
      if (options.data != null) {
        try {
          String encryptedData = await encryptAes(
            TFS().secretKey ?? '',
            jsonEncode(options.data),
          );
          options.data = {'payload': encryptedData};
          // log('Encrypted request body: $encryptedData');
        } catch (e) {
          // log('Failed to encrypt request body: $e');
        }
      }
    }
    // log('...',
    //     name:
    //         "Auth Interceptor from Request ${options.baseUrl}${options.path}");
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log(err.response?.toString() ?? "null body",
        name:
            "Auth Interceptor from Error ${err.requestOptions.baseUrl}${err.requestOptions.path}");
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
    if (TFS().portalToken != null) {
      requestOptions.headers['Authorization'] = TFS().authorization ?? '';
      requestOptions.headers['x-api-client-id'] = TFS().appId ?? '';
      requestOptions.headers['x-subAccountID'] = TFS().clientId ?? '';
      requestOptions.headers['x-aslToken'] = TFS().portalToken ?? '';
      requestOptions.headers['x-api-encryption-key'] =
          encryptRsa(TFS().secretKey ?? "", TFS().publicKey ?? "");
      requestOptions.headers['x-axis-token'] = TFS().portalToken ?? '';
      requestOptions.headers['x-axis-app-id'] = TFS().appId ?? '';
      requestOptions.headers['x-axis-client-id'] = TFS().clientId ?? '';
      requestOptions.headers['Content-Type'] = 'application/json';
      requestOptions.headers['Accept'] = 'application/json';

      // Retry the request
      try {
        final dio = Dio();
        // log('...',
        //     name:
        //         "Auth Interceptor from Retry ${requestOptions.baseUrl}${requestOptions.path}");
        final response = await dio.fetch(requestOptions);
        String data = await decryptData(
            TFS().secretKey!, response.data['data']['payload']);
        var dataJson = jsonDecode(data);
        response.data = dataJson;
        handler.resolve(response);
      } catch (e) {
        // log((e as DioException).response.toString(),
        //     name: "Auth Interceptor from Retry");
        handler.next(DioException(requestOptions: requestOptions, error: e));
      }
    } else {
      //No new token available, pass the original error
      handler.next(DioException(
          requestOptions: requestOptions,
          error: 'Token expired and no new token provided'));
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    String data =
        await decryptData(TFS().secretKey!, response.data['data']['payload']);
    var dataJson = jsonDecode(data);
    response.data = dataJson;
    super.onResponse(response, handler);
  }
}
