import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'network_response.dart';
import 'api_url.dart';

class NetworkCaller {
  NetworkCaller._();

  static Future<NetworkResponse<dynamic>> postRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      debugPrint('POST: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body ?? {}),
      );
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: jsonDecode(response.body),
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: 0,
        errorMessage: e.toString(),
      );
    }
  }

  // Live API: multipart upload for /scan
  static Future<NetworkResponse<dynamic>> scanImageFile({
    required File imageFile,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.scan));
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: jsonDecode(response.body),
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: response.body,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: 0,
        errorMessage: e.toString(),
      );
    }
  }

  // ...existing code...
}
