import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/states.dart';
import '../../products/data/product_models.dart';
import '../../products/data/product_providers.dart';
import '../data/offer_providers.dart';
import '../data/offer_repository.dart';

class MakeOfferScreen extends ConsumerStatefulWidget {
  const MakeOfferScreen({super.key, required this.productId});
  final String productId;

  @override
  ConsumerState<MakeOfferScreen> createState() => _MakeOfferScreenState();
}

class _MakeOfferScreenState extends ConsumerState<MakeOfferScreen> {
  final _cash = TextEditingController();
  String? _selected;
  bool _sending = false;

  @override
  void dispose() {
    _cash.dispose();
    super.dispose();
  }

  Future<void> _send(Product target) async {
    final l = context.l10n;
    if (_selected == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.errSelectProduct)));
      return;
    }
    setState(() => _sending = true);
    try {
      await ref.read(offerRepositoryProvider).sendSwapOffer(
            product: target,
            offeredProductId: _selected!,
            cash: num.tryParse(_cash.text.trim()) ?? 0,
          );
      ref.invalidate(hasPendingOfferProvider(target.id));
      ref.invalidate(outgoingOffersProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.swapOfferSent)));
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final uid = ref.watch(currentUserIdProvider);
    final target = ref.watch(productProvider(widget.productId));
    final mine = uid == null
        ? const AsyncValue<List<Product>>.data([])
        : ref.watch(ownerProductsProvider((uid, true)));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: l.makeOfferTitle,
              subtitle: l.makeOfferSubtitle,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: AsyncView(
                value: target,
                onRetry: () => ref.invalidate(productProvider(widget.productId)),
                data: (p) => ListView(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      AppRadius.screenPadding, 4, AppRadius.screenPadding, 24),
                  children: [
                    _TargetCard(product: p),
                    const SizedBox(height: 24),
                    Text(l.chooseYourProduct,
                        style: AppText.sectionTitle.copyWith(fontSize: 20)),
                    const SizedBox(height: 12),
                    mine.when(
                      loading: () => const LoadingState(),
                      error: (_, _) => ErrorState(
                          onRetry: () => ref.invalidate(ownerProductsProvider)),
                      data: (list) => list.isEmpty
                          ? EmptyState(
                              title: l.noProductsToOffer,
                              message: l.noProductsToOfferHint,
                              icon: Icons.inventory_2_outlined,
                              actionLabel: l.addProduct,
                              onAction: () => context.go(AppRoutes.add),
                            )
                          : Column(
                              children: [
                                for (final m in list)
                                  _MyProductTile(
                                    product: m,
                                    selected: _selected == m.id,
                                    onTap: () =>
                                        setState(() => _selected = m.id),
                                  ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      style: AppFieldStyle.bordered,
                      label: l.cashDiff,
                      hint: l.cashDiffHint,
                      controller: _cash,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(l.cashDiffNote, style: AppText.captionMuted),
                    const SizedBox(height: 20),
                    AppButton(
                      label: l.sendSwapOffer,
                      onPressed: () => _send(p),
                      loading: _sending,
                      height: 56,
                    ),
                    SizedBox(height: lang == 'ar' ? 0 : 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final p = product;
    final city = cityLabel(p.owner?.city, lang);
    final by = p.owner == null
        ? ''
        : city.isEmpty
            ? l.byOwnerNoCity(p.owner!.fullName)
            : l.byOwner(p.owner!.fullName, city);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.requestedProduct,
                    style: AppText.bodyMuted.copyWith(fontSize: 14)),
                const SizedBox(height: 4),
                Text(p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sectionTitle.copyWith(fontSize: 20)),
                const SizedBox(height: 4),
                if (p.price != null)
                  Text(Fmt.price(p.price!, lang), style: AppText.price),
                const SizedBox(height: 8),
                Text(by,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.captionMuted),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 130, child: ProductImage(url: p.cover, radius: 16)),
        ],
      ),
    );
  }
}

class _MyProductTile extends StatelessWidget {
  const _MyProductTile(
      {required this.product, required this.selected, required this.onTap});
  final Product product;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = product;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? AppColors.softMint : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
                color: selected ? AppColors.forestGreen : AppColors.border,
                width: selected ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sectionTitle),
                    const SizedBox(height: 2),
                    Text(
                        p.price == null
                            ? l.priceSwap
                            : Fmt.price(p.price!, context.lang),
                        style: AppText.price.copyWith(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(l.condition(p.condition),
                        style: AppText.captionMuted),
                  ],
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check_circle,
                    color: AppColors.forestGreen, size: 32),
              ],
              const SizedBox(width: 12),
              SizedBox(width: 84, child: ProductImage(url: p.cover, radius: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
