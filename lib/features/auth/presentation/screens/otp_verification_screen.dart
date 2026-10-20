import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sheltame_tenant_app/core/network/api_exception.dart';
import 'package:sheltame_tenant_app/core/service/otp_autofill_service.dart';
import 'package:sheltame_tenant_app/core/service/service_providers.dart';
import 'package:sheltame_tenant_app/core/theme/app_colors.dart';
import 'package:sheltame_tenant_app/core/widgets/primary_button.dart';
import 'package:sheltame_tenant_app/features/auth/data/models/otp_screen_arguments.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/controllers/otp_controller.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/widget/auth_header.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/widget/auth_security_card.dart';
import 'package:sheltame_tenant_app/features/auth/presentation/widget/otp_input.dart';
import 'package:sheltame_tenant_app/routes/app_route_names.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({
    required this.phoneNumber,
    required this.source,
    super.key,
    this.resendAvailableAt,
  });

  final String phoneNumber;
  final OtpEntrySource source;
  final DateTime? resendAvailableAt;

  @override
  ConsumerState<OtpVerificationScreen> createState() {
    return _OtpVerificationScreenState();
  }
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpInputKey = GlobalKey<OtpInputState>();

  Timer? _resendTimer;
  OtpAutofillService? _otpAutofillService;

  String _otp = '';
  String? _verificationError;
  String? _resendMessage;

  DateTime? _resendAvailableAt;
  Duration _resendRemaining = Duration.zero;

  bool _hasSubmittedAutofilledOtp = false;
  bool _isListeningForOtp = false;

  @override
  void initState() {
    super.initState();

    _resendAvailableAt = widget.resendAvailableAt?.toLocal();

    if (_resendAvailableAt != null) {
      _startResendAvailabilityTimer();
    } else {
      _startShortResendDelay();
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _listenForOtp();
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printAppSignature();
      _listenForOtp();
    });
  }

  void _startShortResendDelay() {
    _resendAvailableAt = DateTime.now().add(const Duration(minutes: 2));

    _startResendAvailabilityTimer();
  }

  void _startResendAvailabilityTimer() {
    _resendTimer?.cancel();

    _updateResendRemaining();

    if (_resendRemaining == Duration.zero) {
      return;
    }

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      _updateResendRemaining();

      if (_resendRemaining == Duration.zero) {
        timer.cancel();
      }
    });
  }

  void _updateResendRemaining() {
    final availableAt = _resendAvailableAt;

    if (!mounted) return;

    if (availableAt == null) {
      setState(() {
        _resendRemaining = Duration.zero;
      });

      return;
    }

    final difference = availableAt.difference(DateTime.now());

    setState(() {
      _resendRemaining = difference.isNegative ? Duration.zero : difference;
    });
  }

  String _formatRemainingTime(Duration duration) {
    if (duration <= Duration.zero) {
      return 'now';
    }

    final days = duration.inDays;
    final totalHours = duration.inHours;
    final hours = duration.inHours.remainder(24);
    final totalMinutes = duration.inMinutes;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    }

    if (totalHours > 0) {
      return '${totalHours}h ${minutes}m';
    }

    if (totalMinutes > 0) {
      return '${totalMinutes}m ${seconds}s';
    }

    return '${seconds}s';
  }

  String _maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 7) {
      return phoneNumber;
    }

    final beginning = phoneNumber.substring(0, 6);

    final ending = phoneNumber.substring(phoneNumber.length - 4);

    return '$beginning••••$ending';
  }

  String get _previousRouteName {
    return widget.source == OtpEntrySource.login
        ? AppRouteNames.login
        : AppRouteNames.register;
  }

  Future<void> _listenForOtp() async {
    if (_isListeningForOtp) {
      return;
    }

    _isListeningForOtp = true;

    try {
      final service = _otpAutofillService ??= ref.read(
        otpAutofillServiceProvider,
      );

      if (service == null) {
        return;
      }

      final code = await service.listenForCode();

      if (!mounted || code == null) {
        return;
      }

      final normalizedCode = code.replaceAll(RegExp(r'[^0-9]'), '');

      if (normalizedCode.length != 6) {
        return;
      }

      _otpInputKey.currentState?.setCode(normalizedCode);

      setState(() {
        _otp = normalizedCode;
        _verificationError = null;
      });

      await _submitAutofilledOtp();
    } finally {
      _isListeningForOtp = false;
    }
  }

  Future<void> _printAppSignature() async {
    final service = ref.read(otpAutofillServiceProvider);

    final signature = await service.getAppSignature();

    debugPrint('SheltaMe app signature: $signature');
  }

  Future<void> _submitAutofilledOtp() async {
    if (_hasSubmittedAutofilledOtp) {
      return;
    }

    if (_otp.length != 6) {
      return;
    }

    _hasSubmittedAutofilledOtp = true;

    await _verifyOtp();
  }

  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _verificationError = null;
    });

    if (_otp.length != 6) {
      setState(() {
        _verificationError = 'Enter the complete 6-digit verification code.';
      });

      return;
    }

    final response = await ref
        .read(otpVerificationControllerProvider.notifier)
        .verify(phoneNumber: widget.phoneNumber, otp: _otp);

    if (!mounted) return;

    if (response != null && response.success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));

      context.goNamed(AppRouteNames.login);
    }
  }

  Future<void> _resendOtp() async {
    if (_resendRemaining > Duration.zero) {
      return;
    }

    setState(() {
      _resendMessage = null;
      _verificationError = null;
    });

    final response = await ref
        .read(resendOtpControllerProvider.notifier)
        .resend(phoneNumber: widget.phoneNumber);

    if (!mounted) return;

    if (response != null && response.success) {
      _otpInputKey.currentState?.clear();

      final backendAvailableAt = response.resendAvailableAt?.toLocal();

      final retryAfterSeconds = response.retryAfterSeconds;

      DateTime nextAvailableAt;

      if (backendAvailableAt != null) {
        nextAvailableAt = backendAvailableAt;
      } else if (retryAfterSeconds != null) {
        nextAvailableAt = DateTime.now().add(
          Duration(seconds: retryAfterSeconds),
        );
      } else {
        // UI fallback only.
        // The backend remains responsible for enforcing the limit.
        nextAvailableAt = DateTime.now().add(const Duration(hours: 24));
      }

      setState(() {
        _otp = '';
        _resendMessage = response.message;
        _hasSubmittedAutofilledOtp = false;
        _resendAvailableAt = nextAvailableAt;
      });

      _startResendAvailabilityTimer();

      // Stop the previous listener before starting another.
      _otpAutofillService?.stopListening();
      _isListeningForOtp = false;

      _listenForOtp();
    }
  }

  void _handleVerificationError(Object error) {
    if (!mounted) return;

    setState(() {
      _hasSubmittedAutofilledOtp = false;

      _verificationError = error is ApiException
          ? error.message
          : 'Verification failed. Please try again.';
    });
  }

  void _handleResendError(Object error) {
    if (!mounted) return;

    if (error is ApiException && error.code == 'OTP_RESEND_LIMIT_EXCEEDED') {
      final backendAvailableAt = error.dataDateTime('resend_available_at');

      final retryAfterSeconds = error.dataInt('retry_after_seconds');

      DateTime? nextAvailableAt;

      if (backendAvailableAt != null) {
        nextAvailableAt = backendAvailableAt.toLocal();
      } else if (retryAfterSeconds != null) {
        nextAvailableAt = DateTime.now().add(
          Duration(seconds: retryAfterSeconds),
        );
      }

      setState(() {
        _resendMessage = error.message;

        if (nextAvailableAt != null) {
          _resendAvailableAt = nextAvailableAt;
        }
      });

      if (nextAvailableAt != null) {
        _startResendAvailabilityTimer();
      }

      return;
    }

    setState(() {
      _resendMessage = error is ApiException
          ? error.message
          : 'Could not resend the code.';
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpAutofillService?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(otpVerificationControllerProvider);

    final resendState = ref.watch(resendOtpControllerProvider);

    ref.listen(otpVerificationControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          _handleVerificationError(error);
        },
      );
    });

    ref.listen(resendOtpControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          _handleResendError(error);
        },
      );
    });

    final isVerifying = verificationState.isLoading;

    final isResending = resendState.isLoading;

    final hasResendRestriction = _resendRemaining > Duration.zero;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthHeader(
                showBackButton: true,
                title: 'Phone verification',
                onBackPressed: () {
                  context.goNamed(_previousRouteName);
                },
              ),

              const SizedBox(height: 28),

              Text(
                'Verify your phone',
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 8),

              Text(
                'Enter the 6-digit code sent to',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 2),

              Text(
                _maskPhoneNumber(widget.phoneNumber),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              TextButton(
                onPressed: isVerifying
                    ? null
                    : () {
                        context.goNamed(_previousRouteName);
                      },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Change phone number'),
              ),

              const SizedBox(height: 28),

              Text(
                'Verification code',
                style: Theme.of(context).textTheme.labelLarge,
              ),

              const SizedBox(height: 10),

              OtpInput(
                key: _otpInputKey,
                enabled: !isVerifying,
                hasError: _verificationError != null,
                onChanged: (value) {
                  setState(() {
                    _otp = value;
                    _verificationError = null;

                    if (value.length < 6) {
                      _hasSubmittedAutofilledOtp = false;
                    }
                  });

                  ref
                      .read(otpVerificationControllerProvider.notifier)
                      .clearError();
                },
              ),

              if (_verificationError != null) ...[
                const SizedBox(height: 10),
                Text(
                  _verificationError!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              PrimaryButton(
                label: 'Verify',
                isLoading: isVerifying,
                backgroundColor: AppColors.authentication,
                loadingBackgroundColor: AppColors.authentication,
                foregroundColor: AppColors.onAuthentication,
                loadingIndicatorColor: AppColors.onAuthentication,
                onPressed: _verifyOtp,
              ),

              const SizedBox(height: 18),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Didn\'t receive a code?',
                      style: Theme.of(context).textTheme.bodyMedium
                        ?..copyWith(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                    ),

                    if (hasResendRestriction)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Resend in ${_formatRemainingTime(_resendRemaining)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: isResending ? null : _resendOtp,
                        child: Text(isResending ? 'Sending...' : 'Resend code'),
                      ),
                  ],
                ),
              ),

              if (_resendMessage != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _resendMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: resendState.hasError
                          ? AppColors.error
                          : AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 100),

              const AuthSecurityCard(
                title: 'Keeping your account secure',
                description: 'Never share your verification code with anyone.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
