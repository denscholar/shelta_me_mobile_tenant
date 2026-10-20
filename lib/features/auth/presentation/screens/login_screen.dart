import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sheltame_tenant_app/core/network/api_exception.dart';
import 'package:sheltame_tenant_app/core/theme/app_colors.dart';
import 'package:sheltame_tenant_app/core/widgets/app_text_field.dart';
import 'package:sheltame_tenant_app/core/widgets/primary_button.dart';
import 'package:sheltame_tenant_app/features/auth/data/models/otp_screen_arguments.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/widget/auth_header.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/widget/auth_security_card.dart';
import 'package:sheltame_tenant_app/routes/app_route_names.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = true;
  String? _apiError;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    final phoneNumber = value?.trim() ?? '';

    if (phoneNumber.isEmpty) {
      return 'Enter your phone number.';
    }

    final normalizedPhone = phoneNumber.replaceAll(RegExp(r'[\s\-()]'), '');

    final isValid = RegExp(r'^\+?[0-9]{10,15}$').hasMatch(normalizedPhone);

    if (!isValid) {
      return 'Enter a valid phone number.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Enter your password.';
    }

    if (password.length < 6) {
      return 'Password must contain at least 6 characters.';
    }

    return null;
  }

  String _normalizePhoneNumber(String value) {
    return value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
  }

  Future<void> _submitLogin() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _apiError = null;
    });

    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) return;

    final response = await ref
        .read(authControllerProvider.notifier)
        .login(
          phoneNumber: _normalizePhoneNumber(_phoneController.text),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );

    if (!mounted) return;

    if (response != null && response.success) {
      context.goNamed(AppRouteNames.home);
    }
  }

  void _clearApiError() {
    if (_apiError == null) return;

    setState(() {
      _apiError = null;
    });

    ref.read(authControllerProvider.notifier).clearError();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (!mounted) return;

          if (error is ApiException &&
              error.code == 'PHONE_VERIFICATION_REQUIRED') {
            final phoneNumber =
                error.dataString('phone_number') ??
                _normalizePhoneNumber(_phoneController.text);

            final resendAvailableAt = error.dataDateTime('resend_available_at');

            context.goNamed(
              AppRouteNames.otpVerification,
              extra: OtpScreenArguments(
                phoneNumber: phoneNumber,
                source: OtpEntrySource.login,
                resendAvailableAt: resendAvailableAt,
              ),
            );

            return;
          }

          final message = error is ApiException
              ? error.message
              : 'Login failed. Please try again.';

          setState(() {
            _apiError = message;
          });
        },
      );
    });

    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Log in',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 30),

                const AuthHeader(),

                const SizedBox(height: 28),

                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 8),

                Text(
                  'Log in to keep your home search, applications and inspections in one place.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 26),

                AppTextField(
                  label: 'Phone number',
                  controller: _phoneController,
                  hintText: 'Enter your phone number',
                  requiredField: true,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.phone_outlined,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  validator: _validatePhoneNumber,
                  onChanged: (_) => _clearApiError(),
                ),

                const SizedBox(height: 18),

                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  requiredField: true,
                  obscureText: true,
                  showPasswordToggle: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: _validatePassword,
                  onChanged: (_) => _clearApiError(),
                  onFieldSubmitted: (_) {
                    if (!isLoading) {
                      _submitLogin();
                    }
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        'Remember me',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: AppColors.primaryText),
                      ),
                    ),

                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              // Forgot-password route will be added later.
                            },
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),

                if (_apiError != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _apiError!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 18),

                PrimaryButton(
                  label: 'Log in',
                  isLoading: isLoading,
                  backgroundColor: AppColors.authentication,
                  loadingBackgroundColor: AppColors.authentication,
                  foregroundColor: AppColors.onAuthentication,
                  loadingIndicatorColor: AppColors.onAuthentication,
                  onPressed: _submitLogin,
                ),
                const SizedBox(height: 22),

                const _DividerWithText(text: 'or continue with'),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            // Google authentication will be implemented later.
                          },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.g_mobiledata_rounded,
                          color: AppColors.primary,
                          size: 26,
                        ),
                        SizedBox(width: 8),
                        Text('Google'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New to SheltaMe?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.goNamed(AppRouteNames.register);
                            },
                      child: const Text('Create account'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const AuthSecurityCard(
                  title: 'Your next chapter starts here',
                  description:
                      'Discover verified properties and trusted landlords.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  const _DividerWithText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: AppColors.hintText),
          ),
        ),

        const Expanded(child: Divider()),
      ],
    );
  }
}
