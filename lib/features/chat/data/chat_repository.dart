import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_provider.dart';
import 'chat_models.dart';

class ChatRepository {
  ChatRepository(this._client);
  final SupabaseClient _client;

  String get _uid => _client.auth.currentUser!.id;

  Future<List<Conversation>> conversations() async {
    final rows = await _client
        .from('conversations')
        .select(Conversation.select)
        .order('last_message_at', ascending: false);
    return rows.map<Conversation>(Conversation.fromJson).toList();
  }

  Future<Conversation> conversation(String id) async => Conversation.fromJson(
      await _client.from('conversations').select(Conversation.select).eq('id', id).single());

  /// Live message list (also emits when `read_at` changes → ✓✓ colours).
  Stream<List<Message>> messages(String conversationId) => _client
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('conversation_id', conversationId)
      .order('created_at', ascending: true)
      .map((rows) => rows.map(Message.fromJson).toList());

  Future<void> send(String conversationId, String body) =>
      _client.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': _uid,
        'body': body.trim(),
      });

  Future<void> markRead(String conversationId) => _client
      .rpc('mark_conversation_read', params: {'p_conversation_id': conversationId});

  /// Unread message count per conversation id.
  Future<Map<String, int>> unreadCounts() async {
    final rows = await _client
        .from('messages')
        .select('conversation_id')
        .neq('sender_id', _uid)
        .isFilter('read_at', null);
    final out = <String, int>{};
    for (final r in rows) {
      final id = r['conversation_id'] as String;
      out[id] = (out[id] ?? 0) + 1;
    }
    return out;
  }

  Future<String?> peerPhone(String conversationId) async {
    final r = await _client
        .rpc('get_peer_phone', params: {'p_conversation_id': conversationId});
    return r as String?;
  }

  Future<bool> hasReviewed(String offerId) async {
    final rows = await _client
        .from('reviews')
        .select('id')
        .eq('offer_id', offerId)
        .eq('reviewer_id', _uid)
        .limit(1);
    return rows.isNotEmpty;
  }
}

final chatRepositoryProvider =
    Provider<ChatRepository>((ref) => ChatRepository(ref.watch(supabaseProvider)));
