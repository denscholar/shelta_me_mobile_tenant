import 'package:dio/dio.dart';

import 'api_exception.dart';

abstract final class ApiErrorHandler {
  static ApiException handle(Object error) {
    if (error is ApiException) {
      return error;
    }

    if (error is FormatException) {
      return ApiException(
        message: error.message,
        code: 'INVALID_RESPONSE_FORMAT',
      );
    }

    if (error is! DioException) {
      return const ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          message: 'The request timed out. Please try again.',
          code: 'REQUEST_TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'Unable to connect. Check your internet connection.',
          code: 'CONNECTION_ERROR',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'The request was cancelled.',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.badCertificate:
        return const ApiException(
          message: 'A secure connection could not be established.',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
        return const ApiException(
          message: 'Something went wrong. Please try again.',
          code: 'UNKNOWN_ERROR',
        );
    }
  }

  static ApiException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    if (responseData is Map) {
      final responseMap = Map<String, dynamic>.from(responseData);

      final rawData = responseMap['data'];

      Map<String, dynamic>? parsedData;

      if (rawData is Map) {
        parsedData = Map<String, dynamic>.from(rawData);
      }

      return ApiException(
        message: _extractMessage(responseMap),
        code: responseMap['code'] as String?,
        statusCode: statusCode,
        errors: responseMap['errors'],
        data: parsedData,
      );
    }

    return ApiException(
      message: _messageFromStatusCode(statusCode),
      code: 'HTTP_ERROR',
      statusCode: statusCode,
    );
  }

  static String _extractMessage(Map<String, dynamic> data) {
    final message = data['message'];

    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    return 'The request could not be completed.';
  }

  static String _messageFromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'The information provided is invalid.';

      case 401:
        return 'Your credentials are incorrect.';

      case 403:
        return 'You are not allowed to perform this action.';

      case 404:
        return 'The requested service was not found.';

      case 429:
        return 'Too many attempts. Please try again later.';

      case 500:
      case 502:
      case 503:
        return 'The server is currently unavailable. Please try again later.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
