import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../offers/data/offer_providers.dart';

/// Pending incoming offers + unread chat messages, shown on the "رسائلي" tab.
final messagesBadgeProvider = Provider<int>((ref) {
  return ref.watch(pendingIncomingCountProvider);
});
