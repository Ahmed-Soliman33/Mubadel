import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Unread messages + pending incoming offers, shown on the "رسائلي" tab.
/// Wired to Supabase in the Chat phase.
final messagesBadgeProvider = Provider<int>((ref) => 0);
