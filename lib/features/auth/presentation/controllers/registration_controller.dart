import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/register_request.dart';
import '../../data/models/registration_response.dart';
import '../../providers/auth_providers.dart';

final registrationControllerProvider =
    AsyncNotifierProvider<RegistrationController, RegistrationResponse?>(
      RegistrationController.new,
    );

class RegistrationController extends AsyncNotifier<RegistrationResponse?> {
  @override
  Future<RegistrationResponse?> build() async {
    return null;
  }

  Future<RegistrationResponse?> register({
    required String firstName,
    required String lastName,
    required String? email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncLoading();

    final request = RegisterRequest(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
    );

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);

      return repository.register(request);
    });

    return state.whenOrNull(data: (data) => data);
  }

  void clearError() {
    if (state.hasError) {
      state = const AsyncData(null);
    }
  }
}
