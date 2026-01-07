import 'package:flutter/cupertino.dart';

class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final String message;
  final bool success;
  final ApiError? error;

  ApiResponse({
    required this.statusCode,
    this.data,
    this.error,
    String? message,
  })  : success = statusCode >= 200 && statusCode < 300,
        message = message ??
            error?.message ??
            _defaultMessage(statusCode);

  static String _defaultMessage(int code) {
    switch (code) {
      case 400:
        return "Bad Request";
      case 401:
        return "Unauthorized";
      case 403:
        return "Forbidden";
      case 404:
        return "Not Found";
      case 405:
        return "Method Not Allowed";
      case 500:
        return "Internal Server Error";
      default:
        return "Something went wrong";
    }
  }
}
class ApiError {
  final String code;
  final String message;

  ApiError({
    required this.code,
    required this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] ?? '',
      message: json['message'] ?? 'Something went wrong',
    );
  }
}
