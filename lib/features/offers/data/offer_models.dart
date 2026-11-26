import '../../products/data/product_models.dart';

enum OfferType {
  swap('swap'),
  buy('buy');

  const OfferType(this.db);
  final String db;
  static OfferType from(String? v) =>
      OfferType.values.firstWhere((e) => e.db == v, orElse: () => OfferType.buy);
}

enum OfferStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected'),
  cancelled('cancelled'),
  completed('completed');

  const OfferStatus(this.db);
  final String db;
  static OfferStatus from(String? v) => OfferStatus.values
      .firstWhere((e) => e.db == v, orElse: () => OfferStatus.pending);
}

/// Minimal product info embedded in an offer.
class ProductMini {
  const ProductMini({
    required this.id,
    required this.title,
    required this.images,
    this.price,
    this.ownerId,
    this.city,
  });

  static const select = 'id, title, images, price, owner_id, city';

  final String id;
  final String title;
  final List<String> images;
  final num? price;
  final String? ownerId;
  final String? city;

  String? get cover => images.isEmpty ? null : images.first;

  factory ProductMini.fromJson(Map<String, dynamic> j) => ProductMini(
        id: j['id'] as String,
        title: (j['title'] as String?) ?? '',
        images: ((j['images'] as List?) ?? const []).cast<String>(),
        price: j['price'] as num?,
        ownerId: j['owner_id'] as String?,
        city: j['city'] as String?,
      );
}

class Offer {
  const Offer({
    required this.id,
    required this.type,
    required this.productId,
    required this.offeredProductId,
    required this.senderId,
    required this.receiverId,
    required this.cashAmount,
    required this.note,
    required this.status,
    required this.createdAt,
    this.product,
    this.offered,
    this.sender,
    this.receiver,
  });

  static const select = '*, '
      'product:products!offers_product_id_fkey(${ProductMini.select}), '
      'offered:products!offers_offered_product_id_fkey(${ProductMini.select}), '
      'sender:profiles!offers_sender_id_fkey(${ProfileLite.columns}), '
      'receiver:profiles!offers_receiver_id_fkey(${ProfileLite.columns})';

  final String id;
  final OfferType type;
  final String productId;
  final String? offeredProductId;
  final String senderId;
  final String receiverId;
  final num cashAmount;
  final String? note;
  final OfferStatus status;
  final DateTime createdAt;
  final ProductMini? product;
  final ProductMini? offered;
  final ProfileLite? sender;
  final ProfileLite? receiver;

  bool get isSwap => type == OfferType.swap;

  ProfileLite? peerOf(String myId) => senderId == myId ? receiver : sender;

  factory Offer.fromJson(Map<String, dynamic> j) {
    Map<String, dynamic>? m(String k) =>
        j[k] is Map<String, dynamic> ? j[k] as Map<String, dynamic> : null;
    return Offer(
      id: j['id'] as String,
      type: OfferType.from(j['type'] as String?),
      productId: j['product_id'] as String,
      offeredProductId: j['offered_product_id'] as String?,
      senderId: j['sender_id'] as String,
      receiverId: j['receiver_id'] as String,
      cashAmount: (j['cash_amount'] as num?) ?? 0,
      note: j['note'] as String?,
      status: OfferStatus.from(j['status'] as String?),
      createdAt: DateTime.parse(j['created_at'] as String),
      product: m('product') == null ? null : ProductMini.fromJson(m('product')!),
      offered: m('offered') == null ? null : ProductMini.fromJson(m('offered')!),
      sender: m('sender') == null ? null : ProfileLite.fromJson(m('sender')!),
      receiver:
          m('receiver') == null ? null : ProfileLite.fromJson(m('receiver')!),
    );
  }
}
