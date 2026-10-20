import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/auth_response.dart';
import '../../data/models/login_request.dart';
import '../../providers/auth_providers.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthResponse?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthResponse?> {
  @override
  Future<AuthResponse?> build() async {
    return null;
  }

  Future<AuthResponse?> login({
    required String phoneNumber,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AsyncLoading();

    final request = LoginRequest(phoneNumber: phoneNumber, password: password);

    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);

      return repository.login(request, rememberMe: rememberMe);
    });

    return state.when(
      data: (response) => response,
      loading: () => null,
      // ignore: unnecessary_underscores
      error: (_, __) => null,
    );
  }

  void clearError() {
    if (state.hasError) {
      state = const AsyncData(null);
    }
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);

    await repository.logout();

    state = const AsyncData(null);
  }
}
