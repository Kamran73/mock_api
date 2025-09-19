import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MockInterceptor extends Interceptor {
  static const _responseLocator = 'assets/json/response_locator.json';

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint('----on request----');
    await Future.delayed(const Duration(seconds: 1));

    /// make sure if you added any response json file in assets/json then also add key(end-point) and value(response file path)
    /// of that response file in response_locator.json

    final Map<String, dynamic> responseLocator = jsonDecode(
      await rootBundle.loadString(_responseLocator),
    );

    if (responseLocator.containsKey(options.path)) {
      final data = await rootBundle.load(responseLocator[options.path]);
      final encodedData = utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );

      final response = encodedData.isEmpty
          ? encodedData
          : json.decode(encodedData);

      /// un-comment for sending unknown response
      // handler.reject(
      //   DioException(requestOptions: options),
      // );

      /// un-comment for sending server known response with status code
      // handler.reject(DioException(
      //     requestOptions: options,
      //     response: Response<Map<String, dynamic>>(
      //       requestOptions: options,
      //       data: {
      //         "response": {
      //           "status": false,
      //           "message": "This response is from server"
      //         }
      //       },
      //       statusCode: 401,
      //     )));
      debugPrint("Got mock response: $response");
      handler.resolve(Response(requestOptions: options, data: response));
    } else {
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);

    debugPrint("Got real api response ${response.data}");
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    debugPrint("Got error ${err.error}");
  }
}
