import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_text_field.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.hint,
    this.icon,
    this.validator,
    this.style = AppFieldStyle.filled,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? label;
  final String? hint;
  final IconData? icon;
  final String? Function(T?)? validator;
  final AppFieldStyle style;

  @override
  Widget build(BuildContext context) {
    final filled = style == AppFieldStyle.filled;
    final radius = BorderRadius.circular(
        filled ? AppRadius.authField : AppRadius.formField);
    OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: radius,
        borderSide: filled && c == Colors.transparent
            ? BorderSide.none
            : BorderSide(color: c, width: w));

    final field = DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
      style: AppText.body,
      borderRadius: BorderRadius.circular(16),
      dropdownColor: Colors.white,
      icon: Padding(
        padding: const EdgeInsetsDirectional.only(end: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMuted),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: AppColors.forestGreen),
            ],
          ],
        ),
      ),
      hint: hint == null
          ? null
          : Text(hint!,
              style: AppText.body.copyWith(
                  color: filled
                      ? const Color(0xFFA3A8A7)
                      : AppColors.ink)),
      decoration: InputDecoration(
        filled: true,
        fillColor: filled ? AppColors.inputFill : Colors.white,
        isDense: true,
        contentPadding: EdgeInsetsDirectional.symmetric(
            horizontal: 16, vertical: filled ? 18 : 16),
        errorStyle:
            AppText.captionMuted.copyWith(color: AppColors.error, height: 1.2),
        enabledBorder: b(filled ? Colors.transparent : AppColors.border),
        focusedBorder: b(AppColors.forestGreen, 1.5),
        errorBorder: b(AppColors.error),
        focusedErrorBorder: b(AppColors.error, 1.5),
      ),
    );
    if (label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8, start: 2),
          child: Text(
            label!,
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
