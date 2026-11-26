import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../offers/data/offer_providers.dart';
import 'chat_providers.dart';

/// Unread chat messages + pending incoming offers, shown on the "رسائلي" tab.
final messagesBadgeProvider = Provider<int>((ref) {
  final unread = ref
          .watch(unreadCountsProvider)
          .valueOrNull
          ?.values
          .fold<int>(0, (a, b) => a + b) ??
      0;
  return unread + ref.watch(pendingIncomingCountProvider);
});
