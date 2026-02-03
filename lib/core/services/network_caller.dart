import 'package:flutter/foundation.dart';
import 'network_response.dart';

class NetworkCaller {
  NetworkCaller._();

  static Future<NetworkResponse<dynamic>> getRequest(String url) async {
    debugPrint('GET: $url');
    return const NetworkResponse(isSuccess: true, statusCode: 200, data: null);
  }

  static Future<NetworkResponse<dynamic>> postRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    debugPrint('POST: $url');
    return const NetworkResponse(isSuccess: true, statusCode: 200, data: null);
  }
}
