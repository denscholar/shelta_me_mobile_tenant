import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Reusable labelled text field for SheltaMe forms.
///
/// Supports validation, icons, multiline input, read-only selection fields,
/// and an optional built-in password visibility toggle.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.requiredField = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofillHints,
  }) : assert(
          !(controller != null && initialValue != null),
          'Provide either controller or initialValue, not both.',
        ),
        assert(maxLines == null || maxLines >= 1),
        assert(minLines == null || maxLines == null || minLines <= maxLines);

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool showPasswordToggle;
  final bool requiredField;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _isObscured = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelLarge;
    final effectiveSuffixIcon = widget.showPasswordToggle
        ? IconButton(
            tooltip: _isObscured ? 'Show password' : 'Hide password',
            onPressed: () => setState(() => _isObscured = !_isObscured),
            icon: Icon(
              _isObscured
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.secondaryText,
              size: 20,
            ),
          )
        : widget.suffixIcon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: labelStyle,
            children: [
              TextSpan(text: widget.label),
              if (widget.requiredField)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.error),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          obscureText: widget.showPasswordToggle ? _isObscured : widget.obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.showPasswordToggle || widget.obscureText
              ? 1
              : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          autofillHints: widget.autofillHints,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hintText,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: AppColors.secondaryText,
                  ),
            suffixIcon: effectiveSuffixIcon,
          ),
        ),
      ],
    );
  }
}
