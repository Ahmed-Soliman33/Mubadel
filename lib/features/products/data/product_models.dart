enum ProductCondition {
  newItem('new'),
  likeNew('like_new'),
  used('used');

  const ProductCondition(this.db);
  final String db;
  static ProductCondition from(String? v) => ProductCondition.values
      .firstWhere((e) => e.db == v, orElse: () => ProductCondition.used);
}

enum ListingType {
  sale('sale'),
  swap('swap'),
  both('both');

  const ListingType(this.db);
  final String db;
  static ListingType from(String? v) => ListingType.values
      .firstWhere((e) => e.db == v, orElse: () => ListingType.both);
  bool get allowsSwap => this != sale;
  bool get allowsSale => this != swap;
}

enum ProductStatus {
  available('available'),
  reserved('reserved'),
  swapped('swapped'),
  sold('sold');

  const ProductStatus(this.db);
  final String db;
  static ProductStatus from(String? v) => ProductStatus.values
      .firstWhere((e) => e.db == v, orElse: () => ProductStatus.available);
}

class Category {
  const Category({
    required this.id,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.color,
  });

  final int id;
  final String slug;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String color; // '#RRGGBB'

  String name(String lang) => lang == 'ar' ? nameAr : nameEn;

  factory Category.fromJson(Map<String, dynamic> j) => Category(
        id: j['id'] as int,
        slug: j['slug'] as String,
        nameAr: j['name_ar'] as String,
        nameEn: j['name_en'] as String,
        icon: j['icon'] as String,
        color: j['color'] as String,
      );
}

/// Public (non-sensitive) profile columns only. Never contains phone/address.
class ProfileLite {
  const ProfileLite({
    required this.id,
    required this.fullName,
    this.city,
    this.avatarUrl,
    this.isVerified = false,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.swapsCount = 0,
    this.createdAt,
  });

  /// Columns allowed by the column-level grants on `profiles`.
  static const columns =
      'id, full_name, city, avatar_url, is_verified, rating_avg, rating_count, swaps_count, created_at';

  final String id;
  final String fullName;
  final String? city;
  final String? avatarUrl;
  final bool isVerified;
  final double ratingAvg;
  final int ratingCount;
  final int swapsCount;
  final DateTime? createdAt;

  factory ProfileLite.fromJson(Map<String, dynamic> j) => ProfileLite(
        id: j['id'] as String,
        fullName: (j['full_name'] as String?) ?? '',
        city: j['city'] as String?,
        avatarUrl: j['avatar_url'] as String?,
        isVerified: (j['is_verified'] as bool?) ?? false,
        ratingAvg: ((j['rating_avg'] as num?) ?? 0).toDouble(),
        ratingCount: (j['rating_count'] as int?) ?? 0,
        swapsCount: (j['swaps_count'] as int?) ?? 0,
        createdAt: j['created_at'] == null
            ? null
            : DateTime.parse(j['created_at'] as String),
      );
}

class Product {
  const Product({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.condition,
    required this.listingType,
    required this.price,
    required this.city,
    required this.images,
    required this.status,
    required this.createdAt,
    this.category,
    this.owner,
  });

  /// Select fragment used by feed / details / search.
  static const select =
      '*, category:categories(*), owner:profiles(${ProfileLite.columns})';

  final String id;
  final String ownerId;
  final String title;
  final String description;
  final int categoryId;
  final ProductCondition condition;
  final ListingType listingType;
  final num? price;
  final String? city;
  final List<String> images;
  final ProductStatus status;
  final DateTime createdAt;
  final Category? category;
  final ProfileLite? owner;

  String? get cover => images.isEmpty ? null : images.first;
  bool get isAvailable => status == ProductStatus.available;

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as String,
        ownerId: j['owner_id'] as String,
        title: j['title'] as String,
        description: (j['description'] as String?) ?? '',
        categoryId: j['category_id'] as int,
        condition: ProductCondition.from(j['condition'] as String?),
        listingType: ListingType.from(j['listing_type'] as String?),
        price: j['price'] as num?,
        city: j['city'] as String?,
        images: ((j['images'] as List?) ?? const []).cast<String>(),
        status: ProductStatus.from(j['status'] as String?),
        createdAt: DateTime.parse(j['created_at'] as String),
        category: j['category'] is Map<String, dynamic>
            ? Category.fromJson(j['category'] as Map<String, dynamic>)
            : null,
        owner: j['owner'] is Map<String, dynamic>
            ? ProfileLite.fromJson(j['owner'] as Map<String, dynamic>)
            : null,
      );
}
