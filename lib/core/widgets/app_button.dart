import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

enum AppButtonVariant { primary, accent, outline, mint, danger, light }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.expand = true,
    this.height = 52,
    this.fontSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final bool expand;
  final double height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, side) = switch (variant) {
      AppButtonVariant.primary => (AppColors.forestGreen, Colors.white, null),
      AppButtonVariant.accent => (AppColors.citrus, AppColors.deepPine, null),
      AppButtonVariant.mint => (AppColors.softMint, AppColors.forestGreen, null),
      AppButtonVariant.light => (const Color(0xFFE6E8E7), AppColors.ink, null),
      AppButtonVariant.outline => (
          Colors.white,
          AppColors.ink,
          const BorderSide(color: AppColors.border)
        ),
      AppButtonVariant.danger => (
          Colors.white,
          AppColors.error,
          const BorderSide(color: AppColors.error)
        ),
    };
    final enabled = onPressed != null && !loading;
    final style = AppText.button.copyWith(color: fg, fontSize: fontSize);

    final child = loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(label,
                    style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          );

    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: Material(
        color: enabled ? bg : bg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.button),
          onTap: enabled ? onPressed : null,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: side == null
                  ? null
                  : Border.fromBorderSide(enabled
                      ? side
                      : side.copyWith(
                          color: side.color.withValues(alpha: 0.5))),
            ),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
