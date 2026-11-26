import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/supabase/supabase_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/states.dart';
import '../data/chat_models.dart';
import '../data/chat_providers.dart';

class ConversationsTab extends ConsumerWidget {
  const ConversationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(conversationsProvider);
    final unread = ref.watch(unreadCountsProvider).valueOrNull ?? const {};
    final uid = ref.watch(currentUserIdProvider) ?? '';

    return RefreshIndicator(
      color: AppColors.forestGreen,
      onRefresh: () async {
        ref.invalidate(unreadCountsProvider);
        ref.invalidate(conversationsProvider);
        await ref.read(conversationsProvider.future);
      },
      child: async.when(
        loading: () => const LoadingState(),
        error: (_, _) => ListView(children: [
          ErrorState(onRetry: () => ref.invalidate(conversationsProvider)),
        ]),
        data: (list) => list.isEmpty
            ? ListView(children: [
                const SizedBox(height: 60),
                EmptyState(
                  title: l.noConversations,
                  message: l.noConversationsHint,
                  icon: Icons.chat_bubble_outline_rounded,
                ),
              ])
            : ListView.separated(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    AppRadius.screenPadding, 4, AppRadius.screenPadding, 24),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _ConversationTile(
                  conversation: list[i],
                  uid: uid,
                  unread: unread[list[i].id] ?? 0,
                ),
              ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile(
      {required this.conversation, required this.uid, required this.unread});
  final Conversation conversation;
  final String uid;
  final int unread;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    final lang = context.lang;
    final peer = c.peerOf(uid);
    final now = DateTime.now();
    final at = c.lastMessageAt.toLocal();
    final when = Fmt.sameDay(at, now) ? Fmt.time(at, lang) : Fmt.date(at, lang);

    return InkWell(
      onTap: () => context.push(AppRoutes.chat(c.id)),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Avatar(name: peer?.fullName ?? '', url: peer?.avatarUrl, size: 52),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(peer?.fullName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.cardTitle),
                      ),
                      Text(when, style: AppText.captionMuted),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            c.lastMessage ?? c.product?.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: unread > 0
                                ? AppText.label
                                : AppText.bodyMuted.copyWith(fontSize: 13)),
                      ),
                      if (unread > 0)
                        Container(
                          margin: const EdgeInsetsDirectional.only(start: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          constraints: const BoxConstraints(minWidth: 22),
                          decoration: BoxDecoration(
                            color: AppColors.forestGreen,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Text(Fmt.number(unread, lang),
                              textAlign: TextAlign.center,
                              style: AppText.caption.copyWith(
                                  color: Colors.white, fontSize: 11)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
                width: 48,
                child: ProductImage(url: c.product?.cover, radius: 10)),
          ],
        ),
      ),
    );
  }
}
