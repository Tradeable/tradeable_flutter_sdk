import 'package:dio/dio.dart';

Future<String> axisHandshake() async {
  final dio = Dio();
  // dio.interceptors.add(LogInterceptor(
  //   request: true,
  //   requestHeader: true,
  //   requestBody: true,
  //   responseHeader: false,
  //   responseBody: true,
  //   error: true,
  // ));
  Response response = await dio.post(
    "https://custauth-apigee.uat.asldt.com/handshake",
    options: Options(
      headers: {
        'x-api-client-id': 'ASLTRADER3',
        'content-type': 'application/json',
        'Authorization': '2u1h5NWkPZxP8L42bzCHLLIBP2VLcZ9RhhFoLLcAScfVNW1K',
      },
    ),
  );

  return response.data['data']['publicKey'];
}
