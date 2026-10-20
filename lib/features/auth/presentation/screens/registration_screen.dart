import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sheltame_tenant_app/core/network/api_exception.dart';
import 'package:sheltame_tenant_app/core/theme/app_colors.dart';
import 'package:sheltame_tenant_app/core/widgets/app_text_field.dart';
import 'package:sheltame_tenant_app/core/widgets/primary_button.dart';
import 'package:sheltame_tenant_app/features/auth/data/models/otp_screen_arguments.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/controllers/registration_controller.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/widget/auth_header.dart';
import 'package:sheltame_tenant_app/routes/app_route_names.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hasAcceptedTerms = false;

  String? _generalApiError;
  String? _firstNameApiError;
  String? _lastNameApiError;
  String? _emailApiError;
  String? _phoneApiError;
  String? _passwordApiError;
  String? _confirmPasswordApiError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value, {required String fieldName}) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Enter your $fieldName.';
    }

    if (name.length < 2) {
      return '$fieldName must contain at least 2 characters.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    // Email is optional for tenant registration.
    if (email.isEmpty) return null;

    final emailPattern = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailPattern.hasMatch(email)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final phoneNumber = value?.trim() ?? '';

    if (phoneNumber.isEmpty) {
      return 'Enter your phone number.';
    }

    final normalized = phoneNumber.replaceAll(RegExp(r'[\s\-()]'), '');

    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(normalized)) {
      return 'Enter a valid phone number.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Enter your password.';
    }

    if (password.length < 8) {
      return 'Password must contain at least 8 characters.';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Confirm your password.';
    }

    if (confirmPassword != _passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  String _normalizePhoneNumber(String value) {
    var phoneNumber = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');

    if (phoneNumber.startsWith('0')) {
      phoneNumber = '234${phoneNumber.substring(1)}';
    }

    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(1);
    }

    return phoneNumber;
  }

  void _clearApiErrors() {
    final hasError =
        _generalApiError != null ||
        _firstNameApiError != null ||
        _lastNameApiError != null ||
        _emailApiError != null ||
        _phoneApiError != null ||
        _passwordApiError != null ||
        _confirmPasswordApiError != null;

    if (!hasError) return;

    setState(() {
      _generalApiError = null;
      _firstNameApiError = null;
      _lastNameApiError = null;
      _emailApiError = null;
      _phoneApiError = null;
      _passwordApiError = null;
      _confirmPasswordApiError = null;
    });

    ref.read(registrationControllerProvider.notifier).clearError();
  }

  void _setApiErrors(Object error) {
    if (error is! ApiException) {
      setState(() {
        _generalApiError = 'Registration failed. Please try again.';
      });

      return;
    }

    setState(() {
      _generalApiError = error.message;
      _firstNameApiError = error.fieldError('first_name');
      _lastNameApiError = error.fieldError('last_name');
      _emailApiError = error.fieldError('email');
      _phoneApiError = error.fieldError('phone_number');
      _passwordApiError = error.fieldError('password');
      _confirmPasswordApiError = error.fieldError('confirm_password');
    });
  }

  Future<void> _submitRegistration() async {
    FocusScope.of(context).unfocus();

    _clearApiErrors();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (!_hasAcceptedTerms) {
      setState(() {
        _generalApiError =
            'You must accept the Terms of Service and Privacy Policy.';
      });

      return;
    }

    final email = _emailController.text.trim();

    final response = await ref
        .read(registrationControllerProvider.notifier)
        .register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: email.isEmpty ? null : email,
          phoneNumber: _normalizePhoneNumber(_phoneController.text),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

    if (!mounted) return;

    if (response != null && response.success) {
      context.goNamed(
        AppRouteNames.otpVerification,
        extra: OtpScreenArguments(
          phoneNumber: response.phoneNumber,
          source: OtpEntrySource.registration,
          resendAvailableAt: null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final registrationState = ref.watch(registrationControllerProvider);

    ref.listen(registrationControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          if (mounted) {
            _setApiErrors(error);
          }
        },
      );
    });

    final isLoading = registrationState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: AutofillGroup(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHeader(
                    showBackButton: true,
                    title: 'Create account',
                    onBackPressed: () {
                      context.goNamed(AppRouteNames.login);
                    },
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Join SheltaMe',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Create your account to get started.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  AppTextField(
                    label: 'First name',
                    controller: _firstNameController,
                    hintText: 'Enter your first name',
                    requiredField: true,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.givenName],
                    errorText: _firstNameApiError,
                    validator: (value) =>
                        _validateName(value, fieldName: 'first name'),
                    onChanged: (_) => _clearApiErrors(),
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    label: 'Last name',
                    controller: _lastNameController,
                    hintText: 'Enter your last name',
                    requiredField: true,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.familyName],
                    errorText: _lastNameApiError,
                    validator: (value) =>
                        _validateName(value, fieldName: 'last name'),
                    onChanged: (_) => _clearApiErrors(),
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    label: 'Email address',
                    controller: _emailController,
                    hintText: 'Enter your email address (optional)',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.email_outlined,
                    autofillHints: const [AutofillHints.email],
                    errorText: _emailApiError,
                    validator: _validateEmail,
                    onChanged: (_) => _clearApiErrors(),
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    label: 'Phone number',
                    controller: _phoneController,
                    hintText: '+234 • Phone number',
                    requiredField: true,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.phone_outlined,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    errorText: _phoneApiError,
                    validator: _validatePhoneNumber,
                    onChanged: (_) => _clearApiErrors(),
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    hintText: 'Create a password',
                    requiredField: true,
                    obscureText: true,
                    showPasswordToggle: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    errorText: _passwordApiError,
                    validator: _validatePassword,
                    onChanged: (_) => _clearApiErrors(),
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    label: 'Confirm password',
                    controller: _confirmPasswordController,
                    hintText: 'Enter your password again',
                    requiredField: true,
                    obscureText: true,
                    showPasswordToggle: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    errorText: _confirmPasswordApiError,
                    validator: _validateConfirmPassword,
                    onChanged: (_) => _clearApiErrors(),
                    onFieldSubmitted: (_) {
                      if (!isLoading) {
                        _submitRegistration();
                      }
                    },
                  ),

                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _hasAcceptedTerms,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onChanged: isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _hasAcceptedTerms = value ?? false;
                                    _generalApiError = null;
                                  });
                                },
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: const [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy.',
                                style: TextStyle(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_generalApiError != null) ...[
                    const SizedBox(height: 14),
                    _RegistrationErrorMessage(message: _generalApiError!),
                  ],

                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Create Account',
                    isLoading: isLoading,
                    backgroundColor: AppColors.authentication,
                    loadingBackgroundColor: AppColors.authentication,
                    foregroundColor: AppColors.onAuthentication,
                    loadingIndicatorColor: AppColors.onAuthentication,
                    onPressed: _submitRegistration,
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.goNamed(AppRouteNames.login);
                              },
                        child: const Text('Log in'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegistrationErrorMessage extends StatelessWidget {
  const _RegistrationErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
