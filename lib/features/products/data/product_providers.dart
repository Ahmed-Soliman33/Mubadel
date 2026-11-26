import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_provider.dart';
import 'product_models.dart';
import 'product_repository.dart';

// ---------------- paging ----------------

class PagedState {
  const PagedState({
    this.items = const [],
    this.loading = true,
    this.loadingMore = false,
    this.hasMore = true,
    this.error = false,
    this.page = 0,
  });

  final List<Product> items;
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final bool error;
  final int page;

  PagedState copyWith({
    List<Product>? items,
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    bool? error,
    int? page,
  }) =>
      PagedState(
        items: items ?? this.items,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        hasMore: hasMore ?? this.hasMore,
        error: error ?? this.error,
        page: page ?? this.page,
      );
}

mixin PagedMixin {
  PagedState get state;
  set state(PagedState value);
  Future<List<Product>> fetchPage(int page);

  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: false);
    try {
      final items = await fetchPage(0);
      state = PagedState(
          items: items,
          loading: false,
          hasMore: items.length >= kPageSize,
          page: 0);
    } catch (_) {
      state = state.copyWith(loading: false, error: true);
    }
  }

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;
    state = state.copyWith(loadingMore: true);
    try {
      final next = state.page + 1;
      final items = await fetchPage(next);
      state = state.copyWith(
        items: [...state.items, ...items],
        loadingMore: false,
        hasMore: items.length >= kPageSize,
        page: next,
      );
    } catch (_) {
      state = state.copyWith(loadingMore: false, hasMore: false);
    }
  }
}

class FeedNotifier extends Notifier<PagedState> with PagedMixin {
  @override
  PagedState build() {
    ref.watch(currentUserIdProvider);
    Future.microtask(refresh);
    return const PagedState();
  }

  @override
  Future<List<Product>> fetchPage(int page) =>
      ref.read(productRepositoryProvider).feed(page);
}

final feedProvider = NotifierProvider<FeedNotifier, PagedState>(FeedNotifier.new);

class SearchNotifier extends AutoDisposeFamilyNotifier<PagedState, SearchQuery>
    with PagedMixin {
  @override
  PagedState build(SearchQuery arg) {
    Future.microtask(refresh);
    return const PagedState();
  }

  @override
  Future<List<Product>> fetchPage(int page) =>
      ref.read(productRepositoryProvider).search(arg, page);
}

final searchResultsProvider = NotifierProvider.autoDispose
    .family<SearchNotifier, PagedState, SearchQuery>(SearchNotifier.new);

// ---------------- simple futures ----------------

final categoriesProvider = FutureProvider<List<Category>>(
    (ref) => ref.watch(productRepositoryProvider).categories());

final productProvider = FutureProvider.autoDispose.family<Product, String>(
    (ref, id) => ref.watch(productRepositoryProvider).byId(id));

/// A user's products. `(ownerId, availableOnly)`.
final ownerProductsProvider = FutureProvider.autoDispose
    .family<List<Product>, (String, bool)>((ref, k) => ref
        .watch(productRepositoryProvider)
        .byOwner(k.$1, availableOnly: k.$2));

final favoriteProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(productRepositoryProvider).favoriteProducts();
});

// ---------------- favorites (optimistic) ----------------

class FavoriteIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    if (ref.watch(currentUserIdProvider) == null) return {};
    _load();
    return {};
  }

  Future<void> _load() async {
    try {
      state = await ref.read(productRepositoryProvider).favoriteIds();
    } catch (_) {}
  }

  Future<void> toggle(String productId) async {
    final adding = !state.contains(productId);
    state = adding ? {...state, productId} : ({...state}..remove(productId));
    try {
      await ref.read(productRepositoryProvider).setFavorite(productId, adding);
      ref.invalidate(favoriteProductsProvider);
    } catch (_) {
      // revert
      state = adding ? ({...state}..remove(productId)) : {...state, productId};
    }
  }
}

final favoriteIdsProvider =
    NotifierProvider<FavoriteIdsNotifier, Set<String>>(FavoriteIdsNotifier.new);
