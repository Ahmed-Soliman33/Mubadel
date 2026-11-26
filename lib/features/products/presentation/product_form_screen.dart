import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/states.dart';
import '../../profile/data/profile_repository.dart';
import '../data/product_models.dart';
import '../data/product_providers.dart';
import '../data/product_repository.dart';

const _kMaxImages = 6;

/// Wrapper for `/product/:id/edit`.
class ProductEditScreen extends ConsumerWidget {
  const ProductEditScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productProvider(productId));
    return Scaffold(
      body: SafeArea(
        child: AsyncView(
          value: async,
          onRetry: () => ref.invalidate(productProvider(productId)),
          data: (p) => ProductFormScreen(existing: p),
        ),
      ),
    );
  }
}

class _FormImage {
  _FormImage.remote(this.url) : file = null;
  _FormImage.local(this.file) : url = null;
  final String? url;
  final XFile? file;
}

/// Add (tab) / edit (stack) product form.
class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key, this.existing});
  final Product? existing;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _picker = ImagePicker();
  final List<_FormImage> _images = [];
  int? _categoryId;
  ProductCondition? _condition;
  ListingType _listing = ListingType.both;
  bool _saving = false;
  bool _showImageError = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    if (p != null) {
      _title.text = p.title;
      _desc.text = p.description;
      _price.text = p.price == null
          ? ''
          : (p.price! % 1 == 0 ? p.price!.toInt().toString() : p.price.toString());
      _categoryId = p.categoryId;
      _condition = p.condition;
      _listing = p.listingType;
      _images.addAll(p.images.map(_FormImage.remote));
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _price.dispose();
    super.dispose();
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _pickImages() async {
    final l = context.l10n;
    final remaining = _kMaxImages - _images.length;
    if (remaining <= 0) {
      _snack(l.maxImages);
      return;
    }
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined,
                  color: AppColors.forestGreen),
              title: Text(l.camera, style: AppText.body),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.forestGreen),
              title: Text(l.gallery, style: AppText.body),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final List<XFile> files;
      if (source == ImageSource.camera) {
        final f = await _picker.pickImage(source: source);
        files = f == null ? [] : [f];
      } else if (remaining == 1) {
        final f = await _picker.pickImage(source: source);
        files = f == null ? [] : [f];
      } else {
        files = await _picker.pickMultiImage(limit: remaining);
      }
      if (files.isEmpty || !mounted) return;
      setState(() {
        _images.addAll(files.take(remaining).map(_FormImage.local));
        _showImageError = false;
      });
    } catch (_) {
      if (mounted) _snack(l.errorGeneric);
    }
  }

  Future<void> _submit() async {
    final l = context.l10n;
    final okFields = _form.currentState!.validate();
    final okImages = _images.isNotEmpty;
    setState(() => _showImageError = !okImages);
    if (!okFields || !okImages || _condition == null) {
      if (_condition == null) _snack(l.errConditionRequired);
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(productRepositoryProvider);
    try {
      // Upload new images, keep order.
      final urls = <String>[
        for (final img in _images)
          if (img.url != null) img.url!,
      ];
      final uploaded = await Future.wait([
        for (final img in _images)
          if (img.file != null) repo.uploadImage(img.file!),
      ]);
      final ordered = <String>[];
      var u = 0;
      for (final img in _images) {
        ordered.add(img.url ?? uploaded[u++]);
      }

      final price = _listing == ListingType.swap
          ? null
          : num.tryParse(_price.text.trim());

      if (_isEdit) {
        final removed = widget.existing!.images
            .where((e) => !urls.contains(e))
            .toList();
        await repo.update(
          widget.existing!.id,
          ProductInput(
            title: _title.text,
            description: _desc.text,
            categoryId: _categoryId!,
            condition: _condition!,
            listingType: _listing,
            price: price,
            images: ordered,
          ),
        );
        if (removed.isNotEmpty) await repo.removeImages(removed);
        ref.invalidate(feedProvider);
        ref.invalidate(ownerProductsProvider);
        ref.invalidate(favoriteProductsProvider);
        if (!mounted) return;
        _snack(l.productSaved);
        context.pop();
      } else {
        final city = ref.read(myProfileProvider).valueOrNull?.base.city ??
            (await ref.read(myProfileProvider.future)).base.city;
        final id = await repo.create(ProductInput(
          title: _title.text,
          description: _desc.text,
          categoryId: _categoryId!,
          condition: _condition!,
          listingType: _listing,
          price: price,
          images: ordered,
          city: city,
        ));
        ref.invalidate(feedProvider);
        ref.invalidate(ownerProductsProvider);
        if (!mounted) return;
        _snack(l.productPublished);
        _reset();
        context.push(AppRoutes.product(id));
      }
    } catch (_) {
      if (mounted) _snack(l.errorGeneric);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _reset() {
    _form.currentState?.reset();
    _title.clear();
    _desc.clear();
    _price.clear();
    setState(() {
      _images.clear();
      _categoryId = null;
      _condition = null;
      _listing = ListingType.both;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final cats = ref.watch(categoriesProvider).valueOrNull ?? const <Category>[];

    return Form(
      key: _form,
      child: Column(
        children: [
          PageHeader(
            title: _isEdit ? l.editProductTitle : l.addProductTitle,
            subtitle: l.addProductSubtitle,
            onBack: _isEdit ? () => context.pop() : null,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  AppRadius.screenPadding, 4, AppRadius.screenPadding, 24),
              children: [
                Text(l.productImages, style: AppText.sectionTitle),
                const SizedBox(height: 12),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(child: _TipTile(text: l.photoTip)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AddImageTile(
                            label: l.addImages, onTap: _pickImages),
                      ),
                    ],
                  ),
                ),
                if (_images.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 88,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (_, i) => _Thumb(
                        image: _images[i],
                        isCover: i == 0,
                        coverLabel: l.coverLabel,
                        onRemove: () => setState(() => _images.removeAt(i)),
                      ),
                    ),
                  ),
                ],
                if (_showImageError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(l.errImagesRequired,
                        style: AppText.captionMuted
                            .copyWith(color: AppColors.error)),
                  ),
                const SizedBox(height: 22),
                Text(l.productData, style: AppText.sectionTitle),
                const SizedBox(height: 12),
                AppTextField(
                  style: AppFieldStyle.bordered,
                  label: l.productName,
                  hint: l.productNameHint,
                  controller: _title,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v != null && v.trim().length >= 3
                      ? null
                      : l.errNameShort,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  style: AppFieldStyle.bordered,
                  label: l.descriptionLabel,
                  hint: l.descriptionHint,
                  controller: _desc,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 14),
                AppDropdownField<int>(
                  style: AppFieldStyle.bordered,
                  label: l.categoryLabel,
                  hint: l.selectCategory,
                  value: _categoryId,
                  items: [
                    for (final c in cats)
                      DropdownMenuItem(
                          value: c.id,
                          child: Text('${c.icon}  ${c.name(lang)}')),
                  ],
                  onChanged: (v) => setState(() => _categoryId = v),
                  validator: (v) => v == null ? l.errCategoryRequired : null,
                ),
                const SizedBox(height: 14),
                Text(l.productCondition,
                    style: AppText.captionMuted.copyWith(fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final c in ProductCondition.values) ...[
                      _Chip(
                        label: l.condition(c),
                        selected: _condition == c,
                        onTap: () => setState(() => _condition = c),
                      ),
                      if (c != ProductCondition.used)
                        const SizedBox(width: 10),
                    ],
                  ],
                ),
                const SizedBox(height: 22),
                Text(l.howToList, style: AppText.sectionTitle),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ListingCard(
                        selected: _listing == ListingType.both,
                        label: l.listingBoth,
                        icon: const Text('↔️', style: TextStyle(fontSize: 24)),
                        onTap: () =>
                            setState(() => _listing = ListingType.both),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ListingCard(
                        selected: _listing == ListingType.swap,
                        label: l.listingSwapShort,
                        icon: const Icon(Icons.swap_horiz_rounded,
                            color: AppColors.forestGreen, size: 28),
                        onTap: () =>
                            setState(() => _listing = ListingType.swap),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ListingCard(
                        selected: _listing == ListingType.sale,
                        label: l.listingSaleShort,
                        icon: Text(l.currencyEgp,
                            style: AppText.cardTitle.copyWith(
                                color: AppColors.forestGreen, fontSize: 18)),
                        onTap: () =>
                            setState(() => _listing = ListingType.sale),
                      ),
                    ),
                  ],
                ),
                if (_listing != ListingType.swap) ...[
                  const SizedBox(height: 16),
                  AppTextField(
                    style: AppFieldStyle.bordered,
                    label: l.priceLabel,
                    hint: l.priceHint,
                    controller: _price,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (v) {
                      final n = num.tryParse((v ?? '').trim());
                      return n == null || n <= 0 ? l.errPriceRequired : null;
                    },
                  ),
                ],
                const SizedBox(height: 26),
                AppButton(
                  label: _isEdit ? l.saveChanges : l.publish,
                  onPressed: _submit,
                  loading: _saving,
                  height: 56,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipTile extends StatelessWidget {
  const _TipTile({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minHeight: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.softMint,
          borderRadius: BorderRadius.circular(AppRadius.card + 4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome_rounded,
                color: AppColors.forestGreen, size: 32),
            const SizedBox(height: 10),
            Text(text,
                textAlign: TextAlign.center,
                style: AppText.caption.copyWith(
                    color: AppColors.deepPine, fontWeight: FontWeight.w500)),
          ],
        ),
      );
}

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card + 4),
        child: Container(
          constraints: const BoxConstraints(minHeight: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card + 4),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_rounded,
                  color: AppColors.forestGreen, size: 40),
              Text(label,
                  style: AppText.cardTitle
                      .copyWith(color: AppColors.forestGreen)),
            ],
          ),
        ),
      );
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.image,
    required this.isCover,
    required this.coverLabel,
    required this.onRemove,
  });

  final _FormImage image;
  final bool isCover;
  final String coverLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final provider = image.file != null
        ? Image.file(File(image.file!.path), fit: BoxFit.cover)
        : CachedNetworkImage(imageUrl: image.url!, fit: BoxFit.cover);
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(14), child: provider),
          PositionedDirectional(
            top: 4,
            end: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
          if (isCover)
            PositionedDirectional(
              bottom: 4,
              start: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.forestGreen,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(coverLabel,
                    style: AppText.caption
                        .copyWith(color: Colors.white, fontSize: 10)),
              ),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.softMint : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
                color: selected ? AppColors.softMint : AppColors.border),
          ),
          child: Text(label,
              style: AppText.body.copyWith(
                  color: selected ? AppColors.forestGreen : AppColors.ink,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
        ),
      );
}

class _ListingCard extends StatelessWidget {
  const _ListingCard({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.softMint : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
                color: selected ? AppColors.forestGreen : AppColors.border,
                width: selected ? 1.5 : 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30, child: Center(child: icon)),
              const SizedBox(height: 6),
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(
                      color: selected ? AppColors.forestGreen : AppColors.ink,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500)),
            ],
          ),
        ),
      );
}
