import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/supabase/supabase_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/product_card.dart';
import '../data/product_models.dart';
import '../data/product_providers.dart';

/// Two-column sliver grid of [ProductCard]s with optimistic favorites.
class ProductSliverGrid extends ConsumerWidget {
  const ProductSliverGrid({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoriteIdsProvider);
    final uid = ref.watch(currentUserIdProvider);
    return SliverPadding(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppRadius.screenPadding),
      sliver: SliverLayoutBuilder(
        builder: (context, c) {
          const gap = 12.0;
          final cardW = (c.crossAxisExtent - gap) / 2;
          // image (square) + padding + text block
          final extent = cardW + 150;
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              mainAxisExtent: extent,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final p = products[i];
                return ProductCard(
                  product: p,
                  isFavorite: favs.contains(p.id),
                  onFavorite: p.ownerId == uid
                      ? null
                      : () =>
                          ref.read(favoriteIdsProvider.notifier).toggle(p.id),
                  onTap: () => context.push(AppRoutes.product(p.id)),
                );
              },
              childCount: products.length,
            ),
          );
        },
      ),
    );
  }
}

/// Calls [onEnd] when the scroll position nears the end of the list.
class EndlessScroll extends StatelessWidget {
  const EndlessScroll({super.key, required this.onEnd, required this.child});
  final VoidCallback onEnd;
  final Widget child;

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.pixels >= n.metrics.maxScrollExtent - 400) onEnd();
          return false;
        },
        child: child,
      );
}
