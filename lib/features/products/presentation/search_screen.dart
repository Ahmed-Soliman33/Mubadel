import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/states.dart';
import '../data/product_models.dart';
import '../data/product_providers.dart';
import '../data/product_repository.dart';
import 'product_grid.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.categoryId});
  final int? categoryId;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  late SearchQuery _query = SearchQuery(categoryId: widget.categoryId);

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onText(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _query = _query.copyWith(q: v));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final results = ref.watch(searchResultsProvider(_query));
    final notifier = ref.read(searchResultsProvider(_query).notifier);
    final cats = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final selectedCat = cats.where((c) => c.id == _query.categoryId).firstOrNull;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  AppRadius.screenPadding, 12, AppRadius.screenPadding, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: widget.categoryId == null,
                      onChanged: _onText,
                      textInputAction: TextInputAction.search,
                      style: AppText.body,
                      decoration: InputDecoration(
                        hintText: l.searchHint,
                        hintStyle: AppText.body
                            .copyWith(color: AppColors.textMuted),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 18, vertical: 16),
                        suffixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.textMuted),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.formField),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.formField),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppRadius.formField),
                          borderSide: const BorderSide(
                              color: AppColors.forestGreen, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BackChevron(onTap: () => context.pop()),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppRadius.screenPadding),
                children: [
                  _FilterPill(
                    label: selectedCat?.name(lang) ?? l.filterCategory,
                    active: selectedCat != null,
                    onTap: () async {
                      final r = await _pick<int?>(context, l.filterCategory, [
                        (null, l.filterAll),
                        for (final c in cats) (c.id, '${c.icon}  ${c.name(lang)}'),
                      ], _query.categoryId);
                      if (r != null) {
                        setState(() => _query =
                            _query.copyWith(categoryId: () => r.value));
                      }
                    },
                  ),
                  _FilterPill(
                    label: switch (_query.listing) {
                      null => l.filterType,
                      ListingType.sale => l.filterSale,
                      _ => l.filterSwap,
                    },
                    active: _query.listing != null,
                    onTap: () async {
                      final r = await _pick<ListingType?>(
                          context, l.filterType, [
                        (null, l.filterAll),
                        (ListingType.sale, l.filterSale),
                        (ListingType.swap, l.filterSwap),
                      ], _query.listing);
                      if (r != null) {
                        setState(() =>
                            _query = _query.copyWith(listing: () => r.value));
                      }
                    },
                  ),
                  _FilterPill(
                    label: _query.condition == null
                        ? l.filterCondition
                        : l.condition(_query.condition!),
                    active: _query.condition != null,
                    onTap: () async {
                      final r = await _pick<ProductCondition?>(
                          context, l.filterCondition, [
                        (null, l.filterAll),
                        for (final c in ProductCondition.values)
                          (c, l.condition(c)),
                      ], _query.condition);
                      if (r != null) {
                        setState(() => _query =
                            _query.copyWith(condition: () => r.value));
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: EndlessScroll(
                onEnd: notifier.loadMore,
                child: RefreshIndicator(
                  color: AppColors.forestGreen,
                  onRefresh: notifier.refresh,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (results.loading)
                        const SliverToBoxAdapter(child: LoadingState())
                      else if (results.error && results.items.isEmpty)
                        SliverToBoxAdapter(
                            child: ErrorState(onRetry: notifier.refresh))
                      else if (results.items.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: EmptyState(
                                title: l.emptyNoResults,
                                icon: Icons.search_off_rounded),
                          ),
                        )
                      else
                        ProductSliverGrid(products: results.items),
                      if (results.loadingMore)
                        const SliverToBoxAdapter(child: LoadingState()),
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.softMint : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                  color: active ? AppColors.forestGreen : AppColors.border),
            ),
            child: Row(
              children: [
                Text(label,
                    style: AppText.caption.copyWith(
                        color: active
                            ? AppColors.forestGreen
                            : AppColors.ink,
                        fontSize: 13)),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color:
                        active ? AppColors.forestGreen : AppColors.textMuted),
              ],
            ),
          ),
        ),
      );
}

/// Single-select bottom sheet. Returns a box so `null` values are selectable.
Future<({T value})?> _pick<T>(BuildContext context, String title,
    List<(T, String)> options, T current) {
  return showModalBottomSheet<({T value})>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        children: [
          Text(title, style: AppText.sectionTitle),
          const SizedBox(height: 8),
          for (final o in options)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(o.$2, style: AppText.body),
              trailing: o.$1 == current
                  ? const Icon(Icons.check_circle,
                      color: AppColors.forestGreen)
                  : null,
              onTap: () => Navigator.pop(ctx, (value: o.$1)),
            ),
        ],
      ),
    ),
  );
}
