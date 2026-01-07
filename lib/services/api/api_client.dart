// ignore_for_file: empty_catches
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import '../../providers/auth_provider.dart';
import '../local_data/shared_pref.dart';
import '../local_data/shared_pref_keys.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  static const String noInternetMessage = 'Network not available';
  final int timeoutInSeconds = 10;

  final RetryOptions _retryOptions = const RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 1),
  );

  Map<String, String> _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Map<String, String> get header=>_headers;
  ApiClient() {
    _loadToken();
  }

  // =========================
  // TOKEN & HEADERS
  // =========================
  Future<void> _loadToken() async {
    final token = await SharedPrefService().getStringValue(SharedPrefKey.token);
    print("tokentoken--$token");
    updateHeader(token: token);
  }

  void updateHeader({String? token}) {
    if (token != null) {
      _headers['Authorization'] = 'Bearer $token';
    } else {
      _headers.remove('Authorization');
    }
  }

  // =========================
  // GET
  // =========================
  Future<ApiResponse<dynamic>> get(
    String uri, {
    Map<String, dynamic>? query,
  }) async {
    print("_headers---?" + _headers.toString());
    try {
      final url = Uri.parse(uri).replace(queryParameters: query);
      print("url---" + url.toString());
      final response = await _retryOptions.retry(
        () => http
            .get(url, headers: _headers)
            .timeout(Duration(seconds: timeoutInSeconds)),
        retryIf: (e) => e is TimeoutException || e is SocketException,
      );
      print("response---" + response.toString());
      ApiResponse<dynamic> res = _handleResponse(response);
      return res;
    } catch (e) {
      return ApiResponse(statusCode: 0, message: noInternetMessage);
    }
  }

  // =========================
  // POST
  // =========================
  Future<ApiResponse<dynamic>> post(
    String uri,
    dynamic body, {
    bool noTimeout = false,
  }) async {
    try {
      print("url---" + Uri.parse(uri).toString());
      print("body---" + body.toString());
      print("_headers---" + _headers.toString());
      final request = () =>
          http.post(Uri.parse(uri), headers: _headers, body: jsonEncode(body));

      final response = noTimeout
          ? await request()
          : await _retryOptions.retry(
              () => request().timeout(Duration(seconds: timeoutInSeconds)),
              retryIf: (e) => e is TimeoutException || e is SocketException,
            );
      print("response---" + response.toString());
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(statusCode: 0, message: noInternetMessage);
    }
  }

  // =========================
  // PUT
  // =========================
  Future<ApiResponse<dynamic>> put(String uri, dynamic body) async {
    try {
      final response = await _retryOptions.retry(
        () => http
            .put(Uri.parse(uri), headers: _headers, body: jsonEncode(body))
            .timeout(Duration(seconds: timeoutInSeconds)),
        retryIf: (e) => e is TimeoutException || e is SocketException,
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(statusCode: 0, message: noInternetMessage);
    }
  }

  // =========================
  // PATCH
  // =========================
  Future<ApiResponse<dynamic>> patch(String uri, dynamic body) async {
    try {
      final response = await _retryOptions.retry(
        () => http
            .patch(Uri.parse(uri), headers: _headers, body: jsonEncode(body))
            .timeout(Duration(seconds: timeoutInSeconds)),
        retryIf: (e) => e is TimeoutException || e is SocketException,
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(statusCode: 0, message: noInternetMessage);
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<ApiResponse<dynamic>> delete(String uri) async {
    try {
      final response = await _retryOptions.retry(
        () => http
            .delete(Uri.parse(uri), headers: _headers)
            .timeout(Duration(seconds: timeoutInSeconds)),
        retryIf: (e) => e is TimeoutException || e is SocketException,
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(statusCode: 0, message: noInternetMessage);
    }
  }

  // =========================
  // MULTIPART
  // =========================
  Future<ApiResponse<dynamic>> multipart(
    String uri,
    Map<String, String> body,
    List<MultipartBody> files, {
    String method = 'POST',
  }) async {
    try {
      print("Url--->$uri");
      final request = http.MultipartRequest(method, Uri.parse(uri));
      request.headers.addAll(_headers);
      request.fields.addAll(body);

      for (final file in files) {
        request.files.add(
          await http.MultipartFile.fromPath(file.key, file.file.path),
        );
      }
      print("request.files--->${request.files.length}");
      final response = await _retryOptions.retry(
        () async => http.Response.fromStream(
          await request.send(),
        ).timeout(Duration(seconds: timeoutInSeconds)),
        retryIf: (e) => e is TimeoutException || e is SocketException,
      );
print("response--->$response");
      return _handleResponse(response);
    } catch (e) {
      print("Error---$e");
      return ApiResponse(statusCode: 0, message: noInternetMessage);
    }
  }

  // =========================
  // RESPONSE HANDLER
  // =========================
  ApiResponse<dynamic> _handleResponse(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = response.body;
    }

    if (kDebugMode) {
      print('API [${response.statusCode}] → ${response.request?.url}');
      print(body);
    }

    bool _isLoggingOut = false;

    if (response.statusCode == 401 && !_isLoggingOut) {
      _isLoggingOut = true;
      AuthSession.onUnauthorized?.call();
    }

    return ApiResponse(
      statusCode: response.statusCode,
      data: body,
      message: body is Map ? body['message'] : null,
      error: body['error'] != null
          ? ApiError.fromJson(body['error'])
          : null
    );
  }
}

class MultipartBody {
  final String key;
  final File file;

  MultipartBody(this.key, this.file);
}
