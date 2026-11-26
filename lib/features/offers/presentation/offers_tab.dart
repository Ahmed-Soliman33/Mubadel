import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/supabase/supabase_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/states.dart';
import '../../../core/widgets/status_badge.dart';
import '../../products/data/product_providers.dart';
import '../data/offer_models.dart';
import '../data/offer_providers.dart';
import '../data/offer_repository.dart';

/// "العروض" tab: incoming | outgoing.
class OffersTab extends ConsumerStatefulWidget {
  const OffersTab({super.key});

  @override
  ConsumerState<OffersTab> createState() => _OffersTabState();
}

class _OffersTabState extends ConsumerState<OffersTab> {
  bool _incoming = true;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final provider = _incoming ? incomingOffersProvider : outgoingOffersProvider;
    final async = ref.watch(provider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              AppRadius.screenPadding, 4, AppRadius.screenPadding, 8),
          child: Row(
            children: [
              _SubTab(
                  label: l.offersIncoming,
                  selected: _incoming,
                  onTap: () => setState(() => _incoming = true)),
              const SizedBox(width: 10),
              _SubTab(
                  label: l.offersOutgoing,
                  selected: !_incoming,
                  onTap: () => setState(() => _incoming = false)),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.forestGreen,
            onRefresh: () async => ref.refresh(provider.future),
            child: async.when(
              loading: () => const LoadingState(),
              error: (_, _) => ListView(children: [
                ErrorState(onRetry: () => ref.invalidate(provider)),
              ]),
              data: (offers) => offers.isEmpty
                  ? ListView(children: [
                      const SizedBox(height: 60),
                      EmptyState(
                        title: _incoming
                            ? l.noIncomingOffers
                            : l.noOutgoingOffers,
                        icon: Icons.swap_horiz_rounded,
                      ),
                    ])
                  : ListView.separated(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          AppRadius.screenPadding, 4, AppRadius.screenPadding, 24),
                      itemCount: offers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          OfferCard(offer: offers[i], incoming: _incoming),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubTab extends StatelessWidget {
  const _SubTab(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.softMint : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
                color: selected ? AppColors.softMint : AppColors.border),
          ),
          child: Text(label,
              style: AppText.label.copyWith(
                  color: selected ? AppColors.forestGreen : AppColors.textMuted,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600)),
        ),
      );
}

({Color bg, Color fg}) offerStatusColors(OfferStatus s) => switch (s) {
      OfferStatus.pending => (bg: AppColors.warmPeach, fg: AppColors.peachText),
      OfferStatus.accepted => (bg: AppColors.citrus, fg: AppColors.deepPine),
      OfferStatus.completed => (bg: AppColors.softMint, fg: AppColors.forestGreen),
      OfferStatus.rejected ||
      OfferStatus.cancelled =>
        (bg: const Color(0xFFFBE4E4), fg: AppColors.error),
    };

String offerStatusLabel(BuildContext context, OfferStatus s) {
  final l = context.l10n;
  return switch (s) {
    OfferStatus.pending => l.offerStatusPending,
    OfferStatus.accepted => l.offerStatusAccepted,
    OfferStatus.rejected => l.offerStatusRejected,
    OfferStatus.cancelled => l.offerStatusCancelled,
    OfferStatus.completed => l.offerStatusCompleted,
  };
}

class OfferCard extends ConsumerStatefulWidget {
  const OfferCard({super.key, required this.offer, required this.incoming});
  final Offer offer;
  final bool incoming;

  @override
  ConsumerState<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends ConsumerState<OfferCard> {
  bool _busy = false;

  Offer get o => widget.offer;

  Future<void> _run(Future<void> Function(OfferRepository r) action,
      String successMsg) async {
    setState(() => _busy = true);
    try {
      await action(ref.read(offerRepositoryProvider));
      ref.invalidate(incomingOffersProvider);
      ref.invalidate(outgoingOffersProvider);
      ref.invalidate(feedProvider);
      ref.invalidate(ownerProductsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(successMsg)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _accept() async {
    setState(() => _busy = true);
    try {
      final convId = await ref.read(offerRepositoryProvider).accept(o.id);
      ref.invalidate(incomingOffersProvider);
      ref.invalidate(feedProvider);
      ref.invalidate(ownerProductsProvider);
      if (mounted) context.push(AppRoutes.chat(convId));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openChat() async {
    setState(() => _busy = true);
    try {
      final id = await ref.read(offerRepositoryProvider).conversationIdForOffer(o.id);
      if (id != null && mounted) context.push(AppRoutes.chat(id));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final uid = ref.watch(currentUserIdProvider) ?? '';
    final peer = o.peerOf(uid);
    final colors = offerStatusColors(o.status);

    Widget actions = const SizedBox.shrink();
    if (o.status == OfferStatus.pending && widget.incoming) {
      actions = Row(children: [
        Expanded(
            child: AppButton(
                label: l.accept,
                height: 44,
                onPressed: _busy ? null : _accept,
                loading: _busy)),
        const SizedBox(width: 10),
        Expanded(
            child: AppButton(
                label: l.reject,
                height: 44,
                variant: AppButtonVariant.danger,
                onPressed: _busy
                    ? null
                    : () => _run((r) => r.reject(o.id), l.offerRejected))),
      ]);
    } else if (o.status == OfferStatus.pending) {
      actions = AppButton(
          label: l.cancelOffer,
          height: 44,
          variant: AppButtonVariant.danger,
          onPressed: _busy
              ? null
              : () => _run((r) => r.cancel(o.id), l.offerCancelled));
    } else if (o.status == OfferStatus.accepted ||
        o.status == OfferStatus.completed) {
      actions = AppButton(
          label: l.openChat,
          height: 44,
          variant: AppButtonVariant.mint,
          icon: Icons.chat_bubble_outline_rounded,
          onPressed: _busy ? null : _openChat);
    }

    return Container(
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
              Expanded(
                child: _MiniProduct(
                    title: o.product?.title ?? '', url: o.product?.cover),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  o.isSwap ? Icons.swap_horiz_rounded : Icons.arrow_forward_rounded,
                  color: AppColors.forestGreen,
                  size: 28,
                ),
              ),
              Expanded(
                child: o.isSwap
                    ? _MiniProduct(
                        title: o.offered?.title ?? '', url: o.offered?.cover)
                    : _BuyBox(
                        label: l.offerBuyLabel,
                        price: Fmt.price(o.cashAmount, lang)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (peer != null) ...[
                Avatar(name: peer.fullName, url: peer.avatarUrl, size: 30),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l.offerWith(peer.fullName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label),
                ),
              ] else
                const Spacer(),
              StatusBadge(
                  label: offerStatusLabel(context, o.status),
                  background: colors.bg,
                  foreground: colors.fg),
            ],
          ),
          if (o.isSwap && o.cashAmount > 0) ...[
            const SizedBox(height: 8),
            Text(l.offerCash(Fmt.price(o.cashAmount, lang)),
                style: AppText.caption.copyWith(color: AppColors.forestGreen)),
          ],
          const SizedBox(height: 4),
          Text(Fmt.date(o.createdAt, lang), style: AppText.captionMuted),
          if (o.status != OfferStatus.rejected &&
              o.status != OfferStatus.cancelled) ...[
            const SizedBox(height: 12),
            actions,
          ],
        ],
      ),
    );
  }
}

class _MiniProduct extends StatelessWidget {
  const _MiniProduct({required this.title, required this.url});
  final String title;
  final String? url;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(width: 72, child: ProductImage(url: url, radius: 14)),
          const SizedBox(height: 6),
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppText.caption),
        ],
      );
}

class _BuyBox extends StatelessWidget {
  const _BuyBox({required this.label, required this.price});
  final String label;
  final String price;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.softMint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(label,
                style: AppText.cardTitle.copyWith(color: AppColors.forestGreen)),
          ),
          const SizedBox(height: 6),
          Text(price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.copyWith(color: AppColors.forestGreen)),
        ],
      );
}
