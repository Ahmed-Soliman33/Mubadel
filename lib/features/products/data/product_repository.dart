import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/supabase/supabase_provider.dart';
import 'product_models.dart';

const kPageSize = 20;
const kProductBucket = 'product-images';

class SearchQuery {
  const SearchQuery({this.q = '', this.categoryId, this.listing, this.condition});

  final String q;
  final int? categoryId;

  /// `sale` → sale|both, `swap` → swap|both, null → all.
  final ListingType? listing;
  final ProductCondition? condition;

  SearchQuery copyWith({
    String? q,
    int? Function()? categoryId,
    ListingType? Function()? listing,
    ProductCondition? Function()? condition,
  }) =>
      SearchQuery(
        q: q ?? this.q,
        categoryId: categoryId != null ? categoryId() : this.categoryId,
        listing: listing != null ? listing() : this.listing,
        condition: condition != null ? condition() : this.condition,
      );

  @override
  bool operator ==(Object other) =>
      other is SearchQuery &&
      other.q == q &&
      other.categoryId == categoryId &&
      other.listing == listing &&
      other.condition == condition;

  @override
  int get hashCode => Object.hash(q, categoryId, listing, condition);
}

class ProductInput {
  const ProductInput({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.condition,
    required this.listingType,
    required this.price,
    required this.images,
    this.city,
  });

  final String title;
  final String description;
  final int categoryId;
  final ProductCondition condition;
  final ListingType listingType;
  final num? price;
  final List<String> images;
  final String? city;

  Map<String, dynamic> toJson() => {
        'title': title.trim(),
        'description': description.trim(),
        'category_id': categoryId,
        'condition': condition.db,
        'listing_type': listingType.db,
        'price': listingType == ListingType.swap ? null : price,
        'images': images,
        if (city != null) 'city': city,
      };
}

class ProductRepository {
  ProductRepository(this._client);
  final SupabaseClient _client;

  String get _uid => _client.auth.currentUser!.id;

  Future<List<Category>> categories() async {
    final rows = await _client.from('categories').select().order('sort');
    return rows.map<Category>(Category.fromJson).toList();
  }

  List<Product> _parse(List<dynamic> rows) =>
      rows.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();

  Future<List<Product>> feed(int page) async {
    final from = page * kPageSize;
    final rows = await _client
        .from('products')
        .select(Product.select)
        .eq('status', 'available')
        .neq('owner_id', _uid)
        .order('created_at', ascending: false)
        .range(from, from + kPageSize - 1);
    return _parse(rows);
  }

  Future<List<Product>> search(SearchQuery s, int page) async {
    final from = page * kPageSize;
    var q = _client
        .from('products')
        .select(Product.select)
        .eq('status', 'available')
        .neq('owner_id', _uid);
    final text = s.q.trim();
    if (text.isNotEmpty) q = q.ilike('title', '%$text%');
    if (s.categoryId != null) q = q.eq('category_id', s.categoryId!);
    if (s.condition != null) q = q.eq('condition', s.condition!.db);
    if (s.listing != null) {
      q = q.inFilter('listing_type', [s.listing!.db, 'both']);
    }
    final rows =
        await q.order('created_at', ascending: false).range(from, from + kPageSize - 1);
    return _parse(rows);
  }

  Future<Product> byId(String id) async {
    final row =
        await _client.from('products').select(Product.select).eq('id', id).single();
    return Product.fromJson(row);
  }

  Future<List<Product>> byOwner(String ownerId, {bool availableOnly = false}) async {
    var q = _client.from('products').select(Product.select).eq('owner_id', ownerId);
    if (availableOnly) q = q.eq('status', 'available');
    return _parse(await q.order('created_at', ascending: false));
  }

  Future<String> create(ProductInput input) async {
    final row = await _client
        .from('products')
        .insert({...input.toJson(), 'owner_id': _uid})
        .select('id')
        .single();
    return row['id'] as String;
  }

  Future<void> update(String id, ProductInput input) async {
    final json = input.toJson()..remove('city');
    await _client.from('products').update(json).eq('id', id);
  }

  Future<void> delete(Product p) async {
    await _client.from('products').delete().eq('id', p.id);
    await _removeImages(p.images);
  }

  // ---------- images ----------

  /// Compresses to 1280px / q75 and uploads to `{uid}/{uuid}.jpg`.
  Future<String> uploadImage(XFile file, {String bucket = kProductBucket}) async {
    final bytes = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 1280,
      minHeight: 1280,
      quality: 75,
      format: CompressFormat.jpeg,
    );
    final data = bytes ?? await File(file.path).readAsBytes();
    final path = '$_uid/${const Uuid().v4()}.jpg';
    await _client.storage.from(bucket).uploadBinary(
          path,
          data,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  Future<void> removeImages(List<String> urls) => _removeImages(urls);

  Future<void> _removeImages(List<String> urls) async {
    final marker = '/$kProductBucket/';
    final paths = [
      for (final u in urls)
        if (u.contains(marker)) Uri.decodeComponent(u.split(marker).last),
    ];
    if (paths.isEmpty) return;
    try {
      await _client.storage.from(kProductBucket).remove(paths);
    } catch (_) {
      // Orphaned files are harmless; never block the user on cleanup.
    }
  }

  // ---------- favorites ----------

  Future<Set<String>> favoriteIds() async {
    final rows =
        await _client.from('favorites').select('product_id').eq('user_id', _uid);
    return {for (final r in rows) r['product_id'] as String};
  }

  Future<List<Product>> favoriteProducts() async {
    final rows = await _client
        .from('favorites')
        .select('created_at, product:products(${Product.select})')
        .eq('user_id', _uid)
        .order('created_at', ascending: false);
    return [
      for (final r in rows)
        if (r['product'] is Map<String, dynamic>)
          Product.fromJson(r['product'] as Map<String, dynamic>),
    ];
  }

  Future<void> setFavorite(String productId, bool value) async {
    if (value) {
      await _client
          .from('favorites')
          .upsert({'user_id': _uid, 'product_id': productId});
    } else {
      await _client
          .from('favorites')
          .delete()
          .eq('user_id', _uid)
          .eq('product_id', productId);
    }
  }

  /// "راسل البائع" → conversation id.
  Future<String> startConversation(String productId) async {
    final id = await _client
        .rpc('start_conversation', params: {'p_product_id': productId});
    return id as String;
  }
}

final productRepositoryProvider =
    Provider<ProductRepository>((ref) => ProductRepository(ref.watch(supabaseProvider)));
