import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/formatters.dart';
import '../utils/l10n_labels.dart';

/// 5 stars. When [onChanged] is set the stars are tappable (review input).
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.showValue = false,
    this.onChanged,
    this.spacing = 2,
  });

  final double rating;
  final double size;
  final bool showValue;
  final ValueChanged<int>? onChanged;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final filled = rating.round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          GestureDetector(
            onTap: onChanged == null ? null : () => onChanged!(i),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              child: Icon(
                i <= filled ? Icons.star_rounded : Icons.star_outline_rounded,
                size: size,
                color: i <= filled ? AppColors.star : AppColors.border,
              ),
            ),
          ),
        if (showValue) ...[
          const SizedBox(width: 8),
          Text(
            Fmt.rating(rating, context.lang),
            style: AppText.cardTitle.copyWith(color: AppColors.star),
          ),
        ],
      ],
    );
  }
}
