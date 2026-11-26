import '../../offers/data/offer_models.dart';
import '../../products/data/product_models.dart';

class Conversation {
  const Conversation({
    required this.id,
    required this.productId,
    required this.offerId,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessage,
    required this.lastMessageAt,
    this.product,
    this.offer,
    this.user1,
    this.user2,
  });

  static const select = '*, '
      'product:products!conversations_product_id_fkey(${ProductMini.select}), '
      'offer:offers!conversations_offer_id_fkey(*, '
      'product:products!offers_product_id_fkey(${ProductMini.select}), '
      'offered:products!offers_offered_product_id_fkey(${ProductMini.select})), '
      'u1:profiles!conversations_user1_id_fkey(${ProfileLite.columns}), '
      'u2:profiles!conversations_user2_id_fkey(${ProfileLite.columns})';

  final String id;
  final String? productId;
  final String? offerId;
  final String user1Id;
  final String user2Id;
  final String? lastMessage;
  final DateTime lastMessageAt;
  final ProductMini? product;
  final Offer? offer;
  final ProfileLite? user1;
  final ProfileLite? user2;

  ProfileLite? peerOf(String myId) => user1Id == myId ? user2 : user1;
  String peerIdOf(String myId) => user1Id == myId ? user2Id : user1Id;

  factory Conversation.fromJson(Map<String, dynamic> j) {
    Map<String, dynamic>? m(String k) =>
        j[k] is Map<String, dynamic> ? j[k] as Map<String, dynamic> : null;
    return Conversation(
      id: j['id'] as String,
      productId: j['product_id'] as String?,
      offerId: j['offer_id'] as String?,
      user1Id: j['user1_id'] as String,
      user2Id: j['user2_id'] as String,
      lastMessage: j['last_message'] as String?,
      lastMessageAt: DateTime.parse(j['last_message_at'] as String),
      product: m('product') == null ? null : ProductMini.fromJson(m('product')!),
      offer: m('offer') == null ? null : Offer.fromJson(m('offer')!),
      user1: m('u1') == null ? null : ProfileLite.fromJson(m('u1')!),
      user2: m('u2') == null ? null : ProfileLite.fromJson(m('u2')!),
    );
  }
}

class Message {
  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.body,
    required this.readAt,
    required this.createdAt,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;

  factory Message.fromJson(Map<String, dynamic> j) => Message(
        id: j['id'] as String,
        conversationId: j['conversation_id'] as String,
        senderId: j['sender_id'] as String,
        body: j['body'] as String,
        readAt:
            j['read_at'] == null ? null : DateTime.parse(j['read_at'] as String),
        createdAt: DateTime.parse(j['created_at'] as String),
      );
}
