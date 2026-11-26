import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_provider.dart';
import '../../offers/data/offer_providers.dart';
import 'chat_models.dart';
import 'chat_repository.dart';

final conversationsProvider =
    FutureProvider.autoDispose<List<Conversation>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return [];
  refreshOnTableChange(ref, 'conversations', 'convs-$uid');
  return ref.watch(chatRepositoryProvider).conversations();
});

/// Kept alive so the nav badge works while other tabs are showing.
final unreadCountsProvider = FutureProvider<Map<String, int>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return {};
  refreshOnTableChange(ref, 'messages', 'unread-$uid');
  return ref.watch(chatRepositoryProvider).unreadCounts();
});

final conversationProvider =
    FutureProvider.autoDispose.family<Conversation, String>((ref, id) {
  // Offer status changes (accept/complete/cancel) must refresh banners.
  refreshOnTableChange(ref, 'offers', 'conv-offer-$id');
  return ref.watch(chatRepositoryProvider).conversation(id);
});

final messagesProvider = StreamProvider.autoDispose
    .family<List<Message>, String>(
        (ref, id) => ref.watch(chatRepositoryProvider).messages(id));

final hasReviewedProvider = FutureProvider.autoDispose.family<bool, String>(
    (ref, offerId) => ref.watch(chatRepositoryProvider).hasReviewed(offerId));
