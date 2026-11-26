import 'package:flutter/material.dart';

import '../../features/products/data/product_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/l10n_labels.dart';

/// Pill badge (12 / SemiBold).
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.background = AppColors.softMint,
    this.foreground = AppColors.forestGreen,
    this.fontSize = 12,
    this.padding =
        const EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 5),
  });

  final String label;
  final Color background;
  final Color foreground;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  /// available = mint, reserved = blue, swapped/sold = peach.
  factory StatusBadge.product(BuildContext context, ProductStatus s) {
    final (bg, fg) = switch (s) {
      ProductStatus.available => (AppColors.softMint, AppColors.forestGreen),
      ProductStatus.reserved => (AppColors.softBlue, AppColors.blueText),
      ProductStatus.swapped ||
      ProductStatus.sold =>
        (AppColors.warmPeach, AppColors.peachText),
    };
    return StatusBadge(
        label: context.l10n.productStatus(s), background: bg, foreground: fg);
  }

  factory StatusBadge.listing(BuildContext context, ListingType t,
          {double fontSize = 12}) =>
      StatusBadge(label: context.l10n.listing(t), fontSize: fontSize);

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.caption
              .copyWith(color: foreground, fontSize: fontSize),
        ),
      );
}
