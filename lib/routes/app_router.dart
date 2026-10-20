import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sheltame_tenant_app/features/auth/data/models/otp_screen_arguments.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/screens/home_screen.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/screens/login_screen.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/screens/registration_screen.dart';
import 'package:sheltame_tenant_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:sheltame_tenant_app/routes/app_route_names.dart';

abstract final class AppRouter {
  static GoRouter createRouter({required bool hasSeenOnboarding}) {
    return GoRouter(
      initialLocation: hasSeenOnboarding ? '/login' : '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          name: AppRouteNames.onboarding,
          builder: (context, state) {
            return const OnboardingScreen();
          },
        ),
        GoRoute(
          path: '/login',
          name: AppRouteNames.login,
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: '/home',
          name: AppRouteNames.home,
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/register',
          name: AppRouteNames.register,
          builder: (context, state) {
            return const RegistrationScreen();
          },
        ),
        GoRoute(
          path: '/verify-phone',
          name: AppRouteNames.otpVerification,
          builder: (context, state) {
            final extra = state.extra;

            if (extra is! OtpScreenArguments) {
              return const Scaffold(
                body: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'A phone number is required for verification.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }

            return OtpVerificationScreen(
              phoneNumber: extra.phoneNumber,
              source: extra.source,
              resendAvailableAt: extra.resendAvailableAt,
            );
          },
        ),
      ],
      errorBuilder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Text(
                state.error?.toString() ?? 'The requested page was not found.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
