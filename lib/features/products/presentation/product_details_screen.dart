import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/governorates.dart';
import '../../../core/router/app_router.dart';
import '../../../core/supabase/supabase_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/states.dart';
import '../../offers/data/offer_providers.dart';
import '../../offers/presentation/buy_request_sheet.dart';
import '../data/product_models.dart';
import '../data/product_providers.dart';
import '../data/product_repository.dart';

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(productProvider(productId));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: l.productDetailsTitle,
              subtitle: l.productDetailsSubtitle,
              onBack: () => context.canPop() ? context.pop() : context.go(AppRoutes.home),
            ),
            Expanded(
              child: AsyncView(
                value: async,
                onRetry: () => ref.invalidate(productProvider(productId)),
                data: (p) => _Body(product: p),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.product});
  final Product product;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  bool _busy = false;

  Product get p => widget.product;

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _message() async {
    setState(() => _busy = true);
    try {
      final id = await ref.read(productRepositoryProvider).startConversation(p.id);
      if (mounted) context.push(AppRoutes.chat(id));
    } catch (_) {
      if (mounted) _snack(context.l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteConfirmTitle, style: AppText.sectionTitle),
        content: Text(l.deleteConfirmBody, style: AppText.body),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.delete,
                  style: const TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(productRepositoryProvider).delete(p);
      ref.invalidate(feedProvider);
      ref.invalidate(ownerProductsProvider);
      ref.invalidate(favoriteProductsProvider);
      if (!mounted) return;
      _snack(l.productDeleted);
      context.pop();
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        _snack(l.errorGeneric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final uid = ref.watch(currentUserIdProvider);
    final isOwner = uid == p.ownerId;
    final favs = ref.watch(favoriteIdsProvider);
    final pending = ref.watch(hasPendingOfferProvider(p.id)).valueOrNull ?? false;
    final owner = p.owner;
    final priceText = p.listingType == ListingType.swap || p.price == null
        ? l.priceSwap
        : Fmt.price(p.price!, lang);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppRadius.screenPadding),
            children: [
              _Gallery(
                images: p.images,
                isFavorite: favs.contains(p.id),
                onFavorite: isOwner
                    ? null
                    : () => ref.read(favoriteIdsProvider.notifier).toggle(p.id),
              ),
              const SizedBox(height: 18),
              Text(p.title, style: AppText.pageTitle),
              const SizedBox(height: 2),
              Text(priceText, style: AppText.priceLarge.copyWith(fontSize: 26)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 11),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.softMint,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(l.listing(p.listingType),
                    style: AppText.caption.copyWith(
                        color: AppColors.forestGreen, fontSize: 13)),
              ),
              const SizedBox(height: 22),
              Text(l.productDetailsTitle, style: AppText.sectionTitle),
              const SizedBox(height: 6),
              if (p.description.isNotEmpty)
                Text(p.description,
                    style: AppText.bodyMuted.copyWith(
                        color: AppColors.ink.withValues(alpha: 0.75),
                        height: 1.6)),
              const SizedBox(height: 10),
              _InfoRow(
                  label: l.categoryLabel,
                  value: p.category == null
                      ? '-'
                      : '${p.category!.icon} ${p.category!.name(lang)}'),
              _InfoRow(
                  label: l.conditionLabel, value: l.condition(p.condition)),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 18),
              Text(l.ownerSection, style: AppText.sectionTitle),
              const SizedBox(height: 12),
              if (owner != null)
                InkWell(
                  onTap: () => context.push(AppRoutes.user(owner.id)),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Avatar(
                            name: owner.fullName,
                            url: owner.avatarUrl,
                            size: 64),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(owner.fullName,
                                  style: AppText.cardTitle
                                      .copyWith(fontSize: 17)),
                              Text(
                                [
                                  cityLabel(owner.city, lang),
                                  if (owner.createdAt != null)
                                    l.memberSince(
                                        Fmt.year(owner.createdAt!, lang)),
                                ].where((e) => e.isNotEmpty).join(' · '),
                                style: AppText.captionMuted,
                              ),
                              if (owner.ratingCount > 0)
                                Text(
                                  '★ ${Fmt.rating(owner.ratingAvg, lang)} '
                                  '${l.ratingsCount(Fmt.number(owner.ratingCount, lang))}',
                                  style: AppText.caption
                                      .copyWith(color: AppColors.star),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        _ActionBar(
          product: p,
          isOwner: isOwner,
          pending: pending,
          busy: _busy,
          onSwap: () async {
            await context.push(AppRoutes.productOffer(p.id));
            ref.invalidate(hasPendingOfferProvider(p.id));
          },
          onBuy: () async {
            await showBuyRequestSheet(context, p);
          },
          onMessage: _message,
          onEdit: () async {
            await context.push(AppRoutes.productEdit(p.id));
            ref.invalidate(productProvider(p.id));
          },
          onDelete: _delete,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text('$label: ', style: AppText.bodyMuted),
            Expanded(child: Text(value, style: AppText.label)),
          ],
        ),
      );
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.product,
    required this.isOwner,
    required this.pending,
    required this.busy,
    required this.onSwap,
    required this.onBuy,
    required this.onMessage,
    required this.onEdit,
    required this.onDelete,
  });

  final Product product;
  final bool isOwner;
  final bool pending;
  final bool busy;
  final VoidCallback onSwap, onBuy, onMessage, onEdit, onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final available = product.isAvailable;
    final type = product.listingType;

    Widget buttons;
    if (isOwner) {
      buttons = Row(children: [
        Expanded(
            child: AppButton(
                label: l.edit,
                onPressed: onEdit,
                variant: AppButtonVariant.outline,
                icon: Icons.edit_outlined)),
        const SizedBox(width: 10),
        Expanded(
            child: AppButton(
                label: l.delete,
                onPressed: busy ? null : onDelete,
                variant: AppButtonVariant.danger,
                icon: Icons.delete_outline)),
      ]);
    } else if (pending) {
      buttons = Row(children: [
        Expanded(
            flex: 3,
            child: AppButton(
                label: l.offerSent,
                onPressed: null,
                variant: AppButtonVariant.accent)),
        const SizedBox(width: 10),
        Expanded(
            flex: 2,
            child: AppButton(
                label: l.messageSeller,
                onPressed: busy || !available ? null : onMessage,
                variant: AppButtonVariant.outline,
                fontSize: 14)),
      ]);
    } else {
      buttons = Row(children: [
        if (type.allowsSwap) ...[
          Expanded(
              flex: 5,
              child: AppButton(
                  label: l.makeOffer,
                  onPressed: available ? onSwap : null,
                  variant: AppButtonVariant.accent,
                  fontSize: 14)),
          const SizedBox(width: 8),
        ],
        if (type.allowsSale) ...[
          Expanded(
              flex: 4,
              child: AppButton(
                  label: l.buy,
                  onPressed: available ? onBuy : null,
                  fontSize: 14)),
          const SizedBox(width: 8),
        ],
        Expanded(
            flex: 4,
            child: AppButton(
                label: l.messageSeller,
                onPressed: busy || !available ? null : onMessage,
                variant: AppButtonVariant.outline,
                fontSize: 14)),
      ]);
    }

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(
          AppRadius.screenPadding, 10, AppRadius.screenPadding, 12),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!available && !isOwner)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warmPeach,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(l.productUnavailable,
                    textAlign: TextAlign.center,
                    style: AppText.caption
                        .copyWith(color: AppColors.peachText, fontSize: 13)),
              ),
            buttons,
          ],
        ),
      ),
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery(
      {required this.images, required this.isFavorite, required this.onFavorite});
  final List<String> images;
  final bool isFavorite;
  final VoidCallback? onFavorite;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final imgs = widget.images;
    final lang = context.lang;
    return AspectRatio(
      aspectRatio: 1.3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imgs.isEmpty)
              const ColoredBox(
                  color: Color(0xFFF0F5F2),
                  child: Icon(Icons.image_outlined,
                      size: 48, color: AppColors.textMuted))
            else
              PageView.builder(
                itemCount: imgs.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) =>
                        _FullScreenViewer(images: imgs, initial: i),
                  )),
                  child: CachedNetworkImage(
                    imageUrl: imgs[i],
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        const ColoredBox(color: Color(0xFFF0F5F2)),
                    errorWidget: (_, _, _) =>
                        const ColoredBox(color: Color(0xFFF0F5F2)),
                  ),
                ),
              ),
            if (widget.onFavorite != null)
              PositionedDirectional(
                top: 14,
                start: 14,
                child: FavoriteButton(
                    isFavorite: widget.isFavorite,
                    onTap: widget.onFavorite!,
                    size: 44),
              ),
            if (imgs.length > 1)
              PositionedDirectional(
                bottom: 14,
                end: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '${Fmt.number(_index + 1, lang)} / ${Fmt.number(imgs.length, lang)}',
                    style: AppText.caption,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FullScreenViewer extends StatelessWidget {
  const _FullScreenViewer({required this.images, required this.initial});
  final List<String> images;
  final int initial;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: PageView.builder(
          controller: PageController(initialPage: initial),
          itemCount: images.length,
          itemBuilder: (_, i) => InteractiveViewer(
            child: Center(
              child: CachedNetworkImage(
                  imageUrl: images[i], fit: BoxFit.contain),
            ),
          ),
        ),
      );
}
