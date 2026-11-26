import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_provider.dart';
import 'offer_models.dart';
import 'offer_repository.dart';

/// Re-runs [ref] whenever [table] changes (RLS limits events to my rows).
void refreshOnTableChange(Ref ref, String table, String channelName) {
  final client = ref.read(supabaseProvider);
  final channel = client
      .channel(channelName)
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: table,
        callback: (_) => ref.invalidateSelf(),
      )
      .subscribe();
  ref.onDispose(() => client.removeChannel(channel));
}

final incomingOffersProvider = FutureProvider.autoDispose<List<Offer>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return [];
  refreshOnTableChange(ref, 'offers', 'offers-in-$uid');
  return ref.watch(offerRepositoryProvider).incoming();
});

final outgoingOffersProvider = FutureProvider.autoDispose<List<Offer>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return [];
  refreshOnTableChange(ref, 'offers', 'offers-out-$uid');
  return ref.watch(offerRepositoryProvider).outgoing();
});

final offerProvider = FutureProvider.autoDispose.family<Offer, String>(
    (ref, id) => ref.watch(offerRepositoryProvider).byId(id));

final hasPendingOfferProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, productId) =>
        ref.watch(offerRepositoryProvider).hasPendingOffer(productId));

/// Count of pending incoming offers (feeds the nav badge).
final pendingIncomingCountProvider = Provider<int>((ref) =>
    ref
        .watch(incomingOffersProvider)
        .valueOrNull
        ?.where((o) => o.status == OfferStatus.pending)
        .length ??
    0);
