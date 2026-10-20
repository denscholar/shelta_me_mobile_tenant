import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheltame_tenant_app/core/theme/app_colors.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    required this.onChanged,
    super.key,
    this.enabled = true,
    this.hasError = false,
  });

  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool hasError;

  @override
  State<OtpInput> createState() => OtpInputState();
}

/// This state class is intentionally public.
///
/// OtpVerificationScreen uses GlobalKey<OtpInputState> to:
/// - Populate the fields after SMS autofill.
/// - Clear all fields after an OTP resend.
class OtpInputState extends State<OtpInput> {
  static const int _otpLength = 6;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(_otpLength, (_) => TextEditingController());

    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  }

  String get otp {
    return _controllers.map((controller) => controller.text).join();
  }

  void setCode(String code) {
    final digits = code.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length != _otpLength) {
      return;
    }

    for (var index = 0; index < _otpLength; index++) {
      _controllers[index].text = digits[index];
    }

    _focusNodes.last.unfocus();

    widget.onChanged(digits);
  }

  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }

    widget.onChanged('');

    if (_focusNodes.isNotEmpty) {
      _focusNodes.first.requestFocus();
    }
  }

  void _handleChanged(String value, int index) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    widget.onChanged(otp);
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Row(
        children: List.generate(_otpLength, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == _otpLength - 1 ? 0 : 8),
              child: SizedBox(
                height: 54,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  enabled: widget.enabled,
                  keyboardType: TextInputType.number,
                  autofillHints: index == 0
                      ? const [AutofillHints.oneTimeCode]
                      : null,
                  textInputAction: index == _otpLength - 1
                      ? TextInputAction.done
                      : TextInputAction.next,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    fillColor: widget.enabled
                        ? AppColors.surface
                        : AppColors.disabledBackground,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: widget.hasError
                            ? AppColors.error
                            : AppColors.border,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                  ),
                  onChanged: (value) {
                    _handleChanged(value, index);
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
