import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/auth_action_response.dart';
import '../../data/models/resend_phone_otp_request.dart';
import '../../data/models/verify_phone_otp_request.dart';
import '../../providers/auth_providers.dart';

final otpVerificationControllerProvider =
    AsyncNotifierProvider<OtpVerificationController, AuthActionResponse?>(
      OtpVerificationController.new,
    );

final resendOtpControllerProvider =
    AsyncNotifierProvider<ResendOtpController, AuthActionResponse?>(
      ResendOtpController.new,
    );

class OtpVerificationController extends AsyncNotifier<AuthActionResponse?> {
  @override
  Future<AuthActionResponse?> build() async {
    return null;
  }

  Future<AuthActionResponse?> verify({
    required String phoneNumber,
    required String otp,
  }) async {
    state = const AsyncLoading();

    final request = VerifyPhoneOtpRequest(phoneNumber: phoneNumber, otp: otp);

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);

      return repository.verifyPhoneOtp(request);
    });

    return state.asData?.value;
  }

  void clearError() {
    if (state.hasError) {
      state = const AsyncData(null);
    }
  }
}

class ResendOtpController extends AsyncNotifier<AuthActionResponse?> {
  @override
  Future<AuthActionResponse?> build() async {
    return null;
  }

  Future<AuthActionResponse?> resend({required String phoneNumber}) async {
    state = const AsyncLoading();

    final request = ResendPhoneOtpRequest(phoneNumber: phoneNumber);

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);

      return repository.resendPhoneOtp(request);
    });

    return state.asData?.value;
  }
}
