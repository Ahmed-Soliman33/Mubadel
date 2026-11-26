import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_provider.dart';
import '../../products/data/product_models.dart';
import 'offer_models.dart';

class OfferRepository {
  OfferRepository(this._client);
  final SupabaseClient _client;

  String get _uid => _client.auth.currentUser!.id;

  List<Offer> _parse(List<dynamic> rows) =>
      rows.map((e) => Offer.fromJson(e as Map<String, dynamic>)).toList();

  Future<List<Offer>> incoming() async => _parse(await _client
      .from('offers')
      .select(Offer.select)
      .eq('receiver_id', _uid)
      .order('created_at', ascending: false));

  Future<List<Offer>> outgoing() async => _parse(await _client
      .from('offers')
      .select(Offer.select)
      .eq('sender_id', _uid)
      .order('created_at', ascending: false));

  Future<Offer> byId(String id) async => Offer.fromJson(
      await _client.from('offers').select(Offer.select).eq('id', id).single());

  Future<int> pendingIncomingCount() async {
    final rows = await _client
        .from('offers')
        .select('id')
        .eq('receiver_id', _uid)
        .eq('status', 'pending');
    return rows.length;
  }

  /// True when I already have a pending offer on this product.
  Future<bool> hasPendingOffer(String productId) async {
    final rows = await _client
        .from('offers')
        .select('id')
        .eq('sender_id', _uid)
        .eq('product_id', productId)
        .eq('status', 'pending')
        .limit(1);
    return rows.isNotEmpty;
  }

  Future<void> sendSwapOffer({
    required Product product,
    required String offeredProductId,
    num cash = 0,
    String? note,
  }) =>
      _client.from('offers').insert({
        'type': 'swap',
        'product_id': product.id,
        'offered_product_id': offeredProductId,
        'sender_id': _uid,
        'receiver_id': product.ownerId,
        'cash_amount': cash,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      });

  Future<void> sendBuyRequest({required Product product, String? note}) =>
      _client.from('offers').insert({
        'type': 'buy',
        'product_id': product.id,
        'sender_id': _uid,
        'receiver_id': product.ownerId,
        'cash_amount': product.price ?? 0,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      });

  Future<String?> conversationIdForOffer(String offerId) async {
    final rows = await _client
        .from('conversations')
        .select('id')
        .eq('offer_id', offerId)
        .limit(1);
    return rows.isEmpty ? null : rows.first['id'] as String;
  }

  // State changes: RPC only.
  Future<String> accept(String offerId) async {
    final id = await _client.rpc('accept_offer', params: {'p_offer_id': offerId});
    return id as String;
  }

  Future<void> reject(String offerId) =>
      _client.rpc('reject_offer', params: {'p_offer_id': offerId});

  Future<void> cancel(String offerId) =>
      _client.rpc('cancel_offer', params: {'p_offer_id': offerId});

  Future<void> complete(String offerId) =>
      _client.rpc('complete_offer', params: {'p_offer_id': offerId});
}

final offerRepositoryProvider =
    Provider<OfferRepository>((ref) => OfferRepository(ref.watch(supabaseProvider)));
