import 'package:dio/dio.dart';
import 'package:sheltame_tenant_app/core/network/api_endpoints.dart';
import 'package:sheltame_tenant_app/core/network/api_error_handler.dart';
import 'package:sheltame_tenant_app/features/auth/data/models/auth_action_response.dart';
import 'package:sheltame_tenant_app/features/auth/data/models/register_request.dart';
import 'package:sheltame_tenant_app/features/auth/data/models/registration_response.dart';
import 'package:sheltame_tenant_app/features/auth/data/models/resend_phone_otp_request.dart';
import 'package:sheltame_tenant_app/features/auth/data/models/verify_phone_otp_request.dart';

import '../models/auth_response.dart';
import '../models/login_request.dart';

class AuthApiService {
  const AuthApiService(this._dio);

  final Dio _dio;

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final responseData = response.data;

      if (responseData == null) {
        throw const FormatException('The server returned an empty response.');
      }

      return AuthResponse.fromJson(responseData);
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<RegistrationResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const FormatException(
          'The server returned an empty registration response.',
        );
      }

      return RegistrationResponse.fromJson(data);
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<AuthActionResponse> verifyPhoneOtp(
    VerifyPhoneOtpRequest request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.verifyPhoneOtp,
        data: request.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const FormatException(
          'The server returned an empty verification response.',
        );
      }

      return AuthActionResponse.fromJson(data);
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }

  Future<AuthActionResponse> resendPhoneOtp(
    ResendPhoneOtpRequest request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.resendPhoneOtp,
        data: request.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const FormatException(
          'The server returned an empty resend response.',
        );
      }

      return AuthActionResponse.fromJson(data);
    } catch (error) {
      throw ApiErrorHandler.handle(error);
    }
  }
}

// Notice that one service now handles all authentication API requests, but each operation has its own typed request and response model.
