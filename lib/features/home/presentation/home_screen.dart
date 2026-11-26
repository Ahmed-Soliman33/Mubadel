import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/states.dart';
import '../../products/data/product_models.dart';
import '../../products/data/product_providers.dart';
import '../../products/presentation/product_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final feed = ref.watch(feedProvider);
    final notifier = ref.read(feedProvider.notifier);

    return EndlessScroll(
      onEnd: notifier.loadMore,
      child: RefreshIndicator(
        color: AppColors.forestGreen,
        onRefresh: () async {
          ref.invalidate(categoriesProvider);
          await notifier.refresh();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: PageHeader(
                title: '',
                titleWidget: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: l.appName,
                      style: AppText.pageTitle
                          .copyWith(fontWeight: FontWeight.w800)),
                  TextSpan(
                      text: ' ${l.tagline}',
                      style: AppText.pageTitle.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.forestGreen)),
                  ])),
                ),
                subtitle: l.slogan,
              ),
            ),
            SliverToBoxAdapter(child: _SearchBar(hint: l.searchHint)),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(child: _Banner()),
            SliverToBoxAdapter(
                child: _SectionTitle(title: l.browseCategories)),
            const SliverToBoxAdapter(child: _CategoriesRow()),
            SliverToBoxAdapter(
              child: _SectionTitle(
                title: l.featured,
                action: l.viewAll,
                onAction: () => context.push(AppRoutes.search),
              ),
            ),
            if (feed.loading)
              const SliverToBoxAdapter(child: LoadingState())
            else if (feed.error && feed.items.isEmpty)
              SliverToBoxAdapter(child: ErrorState(onRetry: notifier.refresh))
            else if (feed.items.isEmpty)
              SliverToBoxAdapter(
                  child: EmptyState(
                      title: l.noProducts, icon: Icons.storefront_outlined))
            else
              ProductSliverGrid(products: feed.items),
            if (feed.loadingMore)
              const SliverToBoxAdapter(child: LoadingState()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppRadius.screenPadding),
        child: GestureDetector(
          onTap: () => context.push(AppRoutes.search),
          child: Container(
            height: 56,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.formField),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Text(hint,
                        style: AppText.body
                            .copyWith(color: AppColors.textMuted))),
                const Icon(Icons.search_rounded,
                    color: AppColors.textMuted, size: 26),
              ],
            ),
          ),
        ),
      );
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppRadius.screenPadding),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 8, 14),
        decoration: BoxDecoration(
          color: AppColors.softMint,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/logo.png',
                      height: 52,
                      color: AppColors.softMint,
                      colorBlendMode: BlendMode.multiply),
                  const SizedBox(height: 4),
                  Text(l.bannerText,
                      style: AppText.cardTitle.copyWith(
                          color: AppColors.deepPine, height: 1.4)),
                  const SizedBox(height: 10),
                  AppButton(
                    label: '${l.bannerButton} ${context.isRtl ? '←' : '→'}',
                    onPressed: () => context.go(AppRoutes.add),
                    variant: AppButtonVariant.accent,
                    expand: false,
                    height: 38,
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const SizedBox(
              width: 96,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  _Emoji('🎧'),
                  _Emoji('📱'),
                  _Emoji('👕'),
                  _Emoji('🎮'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Emoji extends StatelessWidget {
  const _Emoji(this.e);
  final String e;

  @override
  Widget build(BuildContext context) => Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.white, shape: BoxShape.circle),
        child: Text(e, style: const TextStyle(fontSize: 22)),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            AppRadius.screenPadding, 20, AppRadius.screenPadding, 12),
        child: Row(
          children: [
            Text(title, style: AppText.sectionTitle.copyWith(fontSize: 20)),
            const Spacer(),
            if (action != null)
              GestureDetector(
                onTap: onAction,
                child: Text('$action ${context.isRtl ? '←' : '→'}',
                    style: AppText.caption.copyWith(
                        color: AppColors.forestGreen, fontSize: 13)),
              ),
          ],
        ),
      );
}

Color _hex(String h) => Color(int.parse('FF${h.replaceAll('#', '')}', radix: 16));

class _CategoriesRow extends ConsumerWidget {
  const _CategoriesRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(categoriesProvider);
    return SizedBox(
      height: 112,
      child: cats.when(
        loading: () => const SizedBox.shrink(),
        error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(categoriesProvider)),
        data: (list) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppRadius.screenPadding),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, i) => CategoryTile(
            category: list[i],
            onTap: () =>
                context.push('${AppRoutes.search}?category=${list[i].id}'),
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, required this.onTap});
  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          width: 92,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: _hex(category.color), shape: BoxShape.circle),
                child: Text(category.icon,
                    style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 8),
              Text(category.name(context.lang),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(fontSize: 13)),
            ],
          ),
        ),
      );
}
