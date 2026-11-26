import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/governorates.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../../core/widgets/states.dart';
import '../../../core/widgets/status_badge.dart';
import '../../products/data/product_models.dart';
import '../../products/data/product_providers.dart';
import '../data/profile_repository.dart';

/// Shared by "حسابي" (mine) and the public profile.
class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key, required this.userId, required this.isMine});
  final String userId;
  final bool isMine;

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  int _tab = 0;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final profile = ref.watch(profileProvider(widget.userId));
    final products =
        ref.watch(ownerProductsProvider((widget.userId, !widget.isMine)));
    final reviews = ref.watch(reviewsProvider(widget.userId));

    Future<void> refresh() async {
      ref.invalidate(profileProvider(widget.userId));
      ref.invalidate(ownerProductsProvider((widget.userId, !widget.isMine)));
      ref.invalidate(reviewsProvider(widget.userId));
      await ref.read(profileProvider(widget.userId).future).catchError((_) => const ProfileLite(id: '', fullName: ''));
    }

    return Column(
      children: [
        PageHeader(
          title: l.profileTitle,
          showLogo: false,
          onBack: widget.isMine ? null : () => context.pop(),
          trailing: widget.isMine
              ? IconButton(
                  onPressed: () => context.push(AppRoutes.settings),
                  icon: const Icon(Icons.settings_outlined,
                      color: AppColors.ink, size: 28),
                )
              : null,
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        Expanded(
          child: AsyncView(
            value: profile,
            onRetry: refresh,
            data: (p) => RefreshIndicator(
              color: AppColors.forestGreen,
              onRefresh: refresh,
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    AppRadius.screenPadding, 20, AppRadius.screenPadding, 24),
                children: [
                  Center(child: Avatar(name: p.fullName, url: p.avatarUrl, size: 104)),
                  const SizedBox(height: 14),
                  Center(
                      child: Text(p.fullName,
                          textAlign: TextAlign.center,
                          style: AppText.pageTitle)),
                  const SizedBox(height: 6),
                  if ((p.city ?? '').isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cityLabel(p.city, lang),
                            style: AppText.bodyMuted.copyWith(fontSize: 15)),
                        const SizedBox(width: 4),
                        const Icon(Icons.my_location_rounded,
                            size: 16, color: AppColors.textMuted),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Center(
                    child: RatingStars(
                        rating: p.ratingAvg, size: 26, showValue: true),
                  ),
                  if (p.isVerified) ...[
                    const SizedBox(height: 8),
                    Center(
                        child: Text(l.verifiedMember,
                            style: AppText.bodyMuted.copyWith(fontSize: 13))),
                  ],
                  const SizedBox(height: 18),
                  _StatsCard(
                    rating: Fmt.rating(p.ratingAvg, lang),
                    swaps: Fmt.number(p.swapsCount, lang),
                    items: Fmt.number(products.valueOrNull?.length ?? 0, lang),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Text(widget.isMine ? l.myItems : l.userItems,
                          style: AppText.pageTitle.copyWith(fontSize: 22)),
                      const Spacer(),
                      if (_tab == 0 && (products.valueOrNull?.length ?? 0) > 4)
                        GestureDetector(
                          onTap: () => setState(() => _expanded = !_expanded),
                          child: Text(
                              _expanded
                                  ? '${l.viewAll} ${context.isRtl ? '↑' : '↑'}'
                                  : '${l.viewAll} ${context.isRtl ? '←' : '→'}',
                              style: AppText.caption.copyWith(
                                  color: AppColors.forestGreen,
                                  fontSize: 13)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _TabButton(
                          label: widget.isMine ? l.tabMyReviews : l.tabReviews,
                          selected: _tab == 1,
                          onTap: () => setState(() => _tab = 1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TabButton(
                          label: widget.isMine ? l.tabMyProducts : l.tabProducts,
                          selected: _tab == 0,
                          onTap: () => setState(() => _tab = 0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_tab == 0)
                    products.when(
                      loading: () => const LoadingState(),
                      error: (_, _) => ErrorState(
                          onRetry: () => ref.invalidate(ownerProductsProvider)),
                      data: (list) => list.isEmpty
                          ? EmptyState(
                              title: l.noMyProducts,
                              icon: Icons.inventory_2_outlined)
                          : _ProductsGrid(
                              products: _expanded ? list : list.take(4).toList()),
                    )
                  else
                    reviews.when(
                      loading: () => const LoadingState(),
                      error: (_, _) => ErrorState(
                          onRetry: () => ref.invalidate(reviewsProvider)),
                      data: (list) => list.isEmpty
                          ? EmptyState(
                              title: l.noReviews, icon: Icons.star_outline_rounded)
                          : Column(
                              children: [
                                for (final r in list) _ReviewTile(review: r),
                              ],
                            ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard(
      {required this.rating, required this.swaps, required this.items});
  final String rating;
  final String swaps;
  final String items;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget cell(String value, String label) => Expanded(
          child: Column(
            children: [
              Text(value,
                  style: AppText.pageTitle
                      .copyWith(color: Colors.white, fontSize: 26)),
              Text(label,
                  style: AppText.caption
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w400)),
            ],
          ),
        );
    final divider = Container(
        width: 1, height: 44, color: Colors.white.withValues(alpha: 0.35));
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.forestGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          cell(rating, l.statRating),
          divider,
          cell(swaps, l.statSwaps),
          divider,
          cell(items, l.statItems),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.softMint : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(
                color: selected ? AppColors.softMint : AppColors.border),
          ),
          child: Text(label,
              style: AppText.cardTitle.copyWith(
                  color: selected ? AppColors.forestGreen : AppColors.textMuted,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500)),
        ),
      );
}

class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 176,
        ),
        itemBuilder: (_, i) => _MiniProductCard(product: products[i]),
      );
}

class _MiniProductCard extends StatelessWidget {
  const _MiniProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = product;
    final done = p.status == ProductStatus.swapped || p.status == ProductStatus.sold;
    final sub = done
        ? l.subDone
        : switch (p.listingType) {
            ListingType.swap => l.subForSwap,
            ListingType.sale => l.subForSale,
            ListingType.both => l.subForBoth,
          };
    return InkWell(
      onTap: () => context.push(AppRoutes.product(p.id)),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: StatusBadge.product(context, p.status),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(width: 52, child: ProductImage(url: p.cover, radius: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.cardTitle),
            ),
            Text(sub, style: AppText.captionMuted),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    final r = review;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(
                  name: r.reviewer?.fullName ?? '',
                  url: r.reviewer?.avatarUrl,
                  size: 38),
              const SizedBox(width: 10),
              Expanded(
                child: Text(r.reviewer?.fullName ?? '',
                    style: AppText.cardTitle),
              ),
              Text(Fmt.date(r.createdAt, context.lang),
                  style: AppText.captionMuted),
            ],
          ),
          const SizedBox(height: 8),
          RatingStars(rating: r.rating.toDouble(), size: 18),
          if ((r.comment ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(r.comment!, style: AppText.body.copyWith(height: 1.5)),
          ],
        ],
      ),
    );
  }
}
