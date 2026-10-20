import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheltame_tenant_app/core/network/network_providers.dart';
import 'package:sheltame_tenant_app/core/storage/storage_providers.dart';

import '../data/repositories/auth_repository.dart';
import '../data/services/auth_api_service.dart';

final authApiServiceProvider =
    Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthApiService(dio);
});

final authRepositoryProvider =
    Provider<AuthRepository>((ref) {
  final apiService = ref.watch(
    authApiServiceProvider,
  );

  final tokenStorage = ref.watch(
    tokenStorageProvider,
  );

  return AuthRepository(
    apiService: apiService,
    tokenStorage: tokenStorage,
  );
});