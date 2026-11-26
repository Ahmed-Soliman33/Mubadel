import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/states.dart';
import '../../products/data/product_providers.dart';
import '../../products/presentation/product_grid.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final favs = ref.watch(favoriteProductsProvider);
    // Hide items un-hearted in this session without waiting for a refetch.
    final ids = ref.watch(favoriteIdsProvider);

    return RefreshIndicator(
      color: AppColors.forestGreen,
      onRefresh: () async => ref.refresh(favoriteProductsProvider.future),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
              child: PageHeader(
                  title: l.favoritesTitle, subtitle: l.favoritesSubtitle)),
          favs.when(
            loading: () => const SliverToBoxAdapter(child: LoadingState()),
            error: (_, _) => SliverToBoxAdapter(
                child: ErrorState(
                    onRetry: () => ref.invalidate(favoriteProductsProvider))),
            data: (list) {
              final shown = list.where((p) => ids.contains(p.id)).toList();
              if (shown.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    title: l.noFavorites,
                    message: l.noFavoritesHint,
                    icon: Icons.favorite_border_rounded,
                  ),
                );
              }
              return ProductSliverGrid(products: shown);
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
