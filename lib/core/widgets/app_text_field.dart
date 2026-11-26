import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

enum AppFieldStyle {
  /// Grey filled, radius 12, bold label above, green icon at the end (Auth).
  filled,

  /// White with border, radius 16, muted label above (forms).
  bordered,
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.enabled = true,
    this.style = AppFieldStyle.filled,
    this.autofillHints,
    this.onSubmitted,
    this.suffixText,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final AppFieldStyle style;
  final Iterable<String>? autofillHints;
  final String? suffixText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final filled = widget.style == AppFieldStyle.filled;
    final radius = BorderRadius.circular(
        filled ? AppRadius.authField : AppRadius.formField);
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: radius,
          borderSide: filled && c == Colors.transparent
              ? BorderSide.none
              : BorderSide(color: c, width: w),
        );

    Widget? suffix;
    if (widget.obscure || widget.icon != null) {
      suffix = Padding(
        padding: const EdgeInsetsDirectional.only(end: 14, start: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.obscure)
              GestureDetector(
                onTap: () => setState(() => _hidden = !_hidden),
                child: Icon(
                  _hidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.forestGreen,
                  size: 24,
                ),
              ),
            if (widget.obscure && widget.icon != null)
              const SizedBox(width: 10),
            if (widget.icon != null)
              Icon(widget.icon, color: AppColors.forestGreen, size: 24),
          ],
        ),
      );
    }

    final field = TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      obscureText: _hidden,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.obscure ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      autofillHints: widget.autofillHints,
      style: AppText.body,
      cursorColor: AppColors.forestGreen,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppText.body.copyWith(
          color: filled ? const Color(0xFFA3A8A7) : AppColors.textMuted,
        ),
        counterText: '',
        suffixText: widget.suffixText,
        suffixIcon: suffix,
        suffixIconConstraints: const BoxConstraints(),
        filled: true,
        fillColor: filled ? AppColors.inputFill : Colors.white,
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: filled ? 18 : 16,
        ),
        isDense: true,
        errorStyle:
            AppText.captionMuted.copyWith(color: AppColors.error, height: 1.2),
        enabledBorder: border(filled ? Colors.transparent : AppColors.border),
        disabledBorder:
            border(filled ? Colors.transparent : AppColors.border),
        focusedBorder: border(AppColors.forestGreen, 1.5),
        errorBorder: border(AppColors.error),
        focusedErrorBorder: border(AppColors.error, 1.5),
      ),
    );

    if (widget.label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8, start: 2),
          child: Text(
            widget.label!,
            style: filled
                ? AppText.label.copyWith(fontWeight: FontWeight.w700)
                : AppText.captionMuted.copyWith(fontSize: 13),
          ),
        ),
        field,
      ],
    );
  }
}
