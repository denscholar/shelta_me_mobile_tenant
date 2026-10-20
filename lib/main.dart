import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sheltame_tenant_app/core/theme/app_theme.dart';
import 'package:sheltame_tenant_app/features/onboarding/services/onboarding_storage.dart';
import 'package:sheltame_tenant_app/routes/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await OnboardingStorage.reset();

  final hasSeenOnboarding = await OnboardingStorage.hasSeenOnboarding();

  final router = AppRouter.createRouter(hasSeenOnboarding: hasSeenOnboarding);

  runApp(ProviderScope(child: SheltaMeApp(router: router)));
}

class SheltaMeApp extends StatelessWidget {
  const SheltaMeApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SheltaMe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
