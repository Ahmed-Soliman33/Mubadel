import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_provider.dart';
import '../../products/data/product_models.dart';

/// The signed-in user's full profile (includes phone/address via RPC).
class MyProfile {
  const MyProfile({
    required this.base,
    this.phone,
    this.address,
  });
  final ProfileLite base;
  final String? phone;
  final String? address;
}

class Review {
  const Review({
    required this.id,
    required this.offerId,
    required this.reviewerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.reviewer,
  });

  final String id;
  final String offerId;
  final String reviewerId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final ProfileLite? reviewer;

  factory Review.fromJson(Map<String, dynamic> j) => Review(
        id: j['id'] as String,
        offerId: j['offer_id'] as String,
        reviewerId: j['reviewer_id'] as String,
        rating: j['rating'] as int,
        comment: j['comment'] as String?,
        createdAt: DateTime.parse(j['created_at'] as String),
        reviewer: j['reviewer'] is Map<String, dynamic>
            ? ProfileLite.fromJson(j['reviewer'] as Map<String, dynamic>)
            : null,
      );
}

class ProfileRepository {
  ProfileRepository(this._client);
  final SupabaseClient _client;

  String get _uid => _client.auth.currentUser!.id;

  /// Public columns only — never `select('*')`.
  Future<ProfileLite> byId(String id) async => ProfileLite.fromJson(await _client
      .from('profiles')
      .select(ProfileLite.columns)
      .eq('id', id)
      .single());

  Future<MyProfile> mine() async {
    final row = await _client.rpc('get_my_profile');
    final j = row is List ? row.first as Map<String, dynamic> : row as Map<String, dynamic>;
    return MyProfile(
      base: ProfileLite.fromJson(j),
      phone: j['phone'] as String?,
      address: j['address'] as String?,
    );
  }

  Future<void> updateMine({
    required String fullName,
    required String phone,
    required String city,
    required String address,
    String? avatarUrl,
  }) =>
      _client.from('profiles').update({
        'full_name': fullName.trim(),
        'phone': phone.trim(),
        'city': city,
        'address': address.trim(),
        'avatar_url': ?avatarUrl,
      }).eq('id', _uid);

  Future<List<Review>> reviewsFor(String userId) async {
    final rows = await _client
        .from('reviews')
        .select('*, reviewer:profiles!reviews_reviewer_id_fkey(${ProfileLite.columns})')
        .eq('reviewee_id', userId)
        .order('created_at', ascending: false);
    return rows.map<Review>(Review.fromJson).toList();
  }

  Future<void> submitReview({
    required String offerId,
    required String revieweeId,
    required int rating,
    String? comment,
  }) =>
      _client.from('reviews').insert({
        'offer_id': offerId,
        'reviewer_id': _uid,
        'reviewee_id': revieweeId,
        'rating': rating,
        'comment': ?(comment != null && comment.trim().isNotEmpty ? comment.trim() : null),
      });

  /// Offer ids I already reviewed.
  Future<Set<String>> myReviewedOfferIds() async {
    final rows = await _client
        .from('reviews')
        .select('offer_id')
        .eq('reviewer_id', _uid);
    return {for (final r in rows) r['offer_id'] as String};
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
    (ref) => ProfileRepository(ref.watch(supabaseProvider)));

final profileProvider = FutureProvider.autoDispose
    .family<ProfileLite, String>(
        (ref, id) => ref.watch(profileRepositoryProvider).byId(id));

final myProfileProvider = FutureProvider<MyProfile>((ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(profileRepositoryProvider).mine();
});

final reviewsProvider = FutureProvider.autoDispose
    .family<List<Review>, String>(
        (ref, id) => ref.watch(profileRepositoryProvider).reviewsFor(id));
