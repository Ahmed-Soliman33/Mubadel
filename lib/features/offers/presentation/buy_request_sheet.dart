import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/product_card.dart';
import '../../products/data/product_models.dart';
import '../data/offer_providers.dart';
import '../data/offer_repository.dart';

/// Returns true when a request was sent.
Future<bool> showBuyRequestSheet(BuildContext context, Product product) async {
  final sent = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _BuySheet(product: product),
  );
  return sent ?? false;
}

class _BuySheet extends ConsumerStatefulWidget {
  const _BuySheet({required this.product});
  final Product product;

  @override
  ConsumerState<_BuySheet> createState() => _BuySheetState();
}

class _BuySheetState extends ConsumerState<_BuySheet> {
  final _note = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(offerRepositoryProvider)
          .sendBuyRequest(product: widget.product, note: _note.text);
      ref.invalidate(hasPendingOfferProvider(widget.product.id));
      ref.invalidate(outgoingOffersProvider);
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.buyRequestSent)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = widget.product;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.buyRequestTitle, style: AppText.sectionTitle),
            const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(
                    width: 72,
                    child: ProductImage(url: p.cover, radius: 14)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.cardTitle),
                      const SizedBox(height: 4),
                      Text(Fmt.price(p.price ?? 0, context.lang),
                          style: AppText.price),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softMint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payments_outlined,
                      color: AppColors.forestGreen),
                  const SizedBox(width: 10),
                  Text(l.cashOnDelivery,
                      style: AppText.label
                          .copyWith(color: AppColors.forestGreen)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppTextField(
              style: AppFieldStyle.bordered,
              label: l.noteOptional,
              hint: l.noteHint,
              controller: _note,
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: 18),
            AppButton(
                label: l.sendBuyRequest, onPressed: _send, loading: _loading),
          ],
        ),
      ),
    );
  }
}
