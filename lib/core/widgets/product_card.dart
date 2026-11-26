import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../features/products/data/product_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/formatters.dart';
import '../utils/l10n_labels.dart';
import 'status_badge.dart';

/// Square cover image with a neutral placeholder.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.url,
    this.radius = 16,
    this.aspectRatio = 1,
  });

  final String? url;
  final double radius;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: const Color(0xFFF0F5F2),
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.textMuted, size: 32),
      ),
    );
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: url == null
            ? placeholder
            : CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (_, _) => placeholder,
                errorWidget: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.isFavorite = false,
    this.onFavorite,
  });

  final Product product;
  final VoidCallback onTap;
  final bool isFavorite;

  /// When null the heart is hidden (e.g. own products).
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = product;
    final priceText = p.listingType == ListingType.swap || p.price == null
        ? l.priceSwap
        : Fmt.price(p.price!, context.lang);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ProductImage(url: p.cover),
                  if (onFavorite != null)
                    PositionedDirectional(
                      top: 8,
                      end: 8,
                      child: FavoriteButton(
                          isFavorite: isFavorite, onTap: onFavorite!),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.cardTitle.copyWith(fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(priceText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.price),
                    const SizedBox(height: 2),
                    Text(l.condition(p.condition),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyMuted.copyWith(fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (p.city != null && p.city!.isNotEmpty)
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14, color: AppColors.error),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: Text(p.city!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.captionMuted),
                                ),
                              ],
                            ),
                          ),
                        const Spacer(),
                        Flexible(
                          flex: 2,
                          child: StatusBadge.listing(context, p.listingType,
                              fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size = 36,
  });

  final bool isFavorite;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: size * 0.55,
            color: AppColors.error,
          ),
        ),
      );
}
