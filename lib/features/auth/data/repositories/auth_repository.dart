import 'package:sheltame_tenant_app/core/storage/token_storage.dart';

import '../models/auth_action_response.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/registration_response.dart';
import '../models/resend_phone_otp_request.dart';
import '../models/verify_phone_otp_request.dart';
import '../services/auth_api_service.dart';

class AuthRepository {
  const AuthRepository({
    required this._apiService,
    required this._tokenStorage,
  });

  final AuthApiService _apiService;
  final TokenStorage _tokenStorage;

  Future<AuthResponse> login(
    LoginRequest request, {
    required bool rememberMe,
  }) async {
    final response = await _apiService.login(request);

    if (rememberMe) {
      await _tokenStorage.saveTokens(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
      );
    } else {
      await _tokenStorage.clearTokens();
    }

    return response;
  }

  Future<RegistrationResponse> register(RegisterRequest request) {
    return _apiService.register(request);
  }

  Future<AuthActionResponse> verifyPhoneOtp(VerifyPhoneOtpRequest request) {
    return _apiService.verifyPhoneOtp(request);
  }

  Future<AuthActionResponse> resendPhoneOtp(ResendPhoneOtpRequest request) {
    return _apiService.resendPhoneOtp(request);
  }

  Future<void> logout() {
    return _tokenStorage.clearTokens();
  }
}
