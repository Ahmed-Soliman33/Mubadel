import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/governorates.dart';
import '../../../core/router/app_router.dart';
import '../../../core/supabase/supabase_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/states.dart';
import '../../offers/data/offer_models.dart';
import '../../offers/data/offer_providers.dart';
import '../../offers/data/offer_repository.dart';
import '../../products/data/product_providers.dart';
import '../data/chat_models.dart';
import '../data/chat_providers.dart';
import '../data/chat_repository.dart';
import 'review_sheet.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});
  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  late final ProviderContainer _container;
  bool _sending = false;

  String get id => widget.conversationId;

  @override
  void initState() {
    super.initState();
    _container = ProviderScope.containerOf(context, listen: false);
    _markRead();
  }

  @override
  void dispose() {
    _input.dispose();
    // Clear the unread badge when leaving.
    _container.invalidate(unreadCountsProvider);
    super.dispose();
  }

  void _markRead() {
    ref.read(chatRepositoryProvider).markRead(id).then((_) {
      if (mounted) ref.invalidate(unreadCountsProvider);
    }).catchError((_) {});
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _input.clear();
    try {
      await ref.read(chatRepositoryProvider).send(id, text);
    } catch (_) {
      if (mounted) {
        _input.text = text;
        _snack(context.l10n.errorGeneric);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<bool> _confirm(String title, String body) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: AppText.sectionTitle),
        content: Text(body, style: AppText.body),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.confirm)),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _dealAction(Conversation c, {required bool complete}) async {
    final l = context.l10n;
    final offerId = c.offerId;
    if (offerId == null) return;
    final ok = complete
        ? await _confirm(l.confirmComplete, l.confirmCompleteBody)
        : await _confirm(l.cancelDeal, l.cancelDealBody);
    if (!ok) return;
    try {
      final repo = ref.read(offerRepositoryProvider);
      complete ? await repo.complete(offerId) : await repo.cancel(offerId);
      ref.invalidate(conversationProvider(id));
      ref.invalidate(incomingOffersProvider);
      ref.invalidate(outgoingOffersProvider);
      ref.invalidate(feedProvider);
      ref.invalidate(ownerProductsProvider);
      if (mounted) _snack(complete ? l.dealCompletedSnack : l.dealCancelledSnack);
    } catch (_) {
      if (mounted) _snack(l.errorGeneric);
    }
  }

  Future<void> _call() async {
    try {
      final phone = await ref.read(chatRepositoryProvider).peerPhone(id);
      if (phone == null || phone.isEmpty) {
        if (mounted) _snack(context.l10n.phoneUnavailable);
        return;
      }
      await launchUrl(Uri(scheme: 'tel', path: phone));
    } catch (_) {
      if (mounted) _snack(context.l10n.phoneUnavailable);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final uid = ref.watch(currentUserIdProvider) ?? '';
    final convAsync = ref.watch(conversationProvider(id));
    final msgsAsync = ref.watch(messagesProvider(id));

    // Keep messages marked read while the screen is open.
    ref.listen(messagesProvider(id), (prev, next) {
      final list = next.valueOrNull;
      if (list != null &&
          list.any((m) => m.senderId != uid && m.readAt == null)) {
        _markRead();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: convAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) => Column(children: [
            PageHeader(title: '', onBack: () => context.pop()),
            Expanded(
                child: ErrorState(
                    onRetry: () => ref.invalidate(conversationProvider(id)))),
          ]),
          data: (c) {
            final peer = c.peerOf(uid);
            final offer = c.offer;
            final active = offer?.status == OfferStatus.accepted;
            final dealOpen = active || offer?.status == OfferStatus.completed;
            return Column(
              children: [
                _Header(
                  name: peer?.fullName ?? '',
                  city: cityLabel(peer?.city, context.lang),
                  avatarUrl: peer?.avatarUrl,
                  showCall: dealOpen,
                  onCall: _call,
                  onBack: () => context.pop(),
                  menu: _menu(c, active),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                Expanded(
                  child: msgsAsync.when(
                    loading: () => const LoadingState(),
                    error: (_, _) => ErrorState(
                        onRetry: () => ref.invalidate(messagesProvider(id))),
                    data: (msgs) =>
                        _MessageList(conversation: c, messages: msgs, uid: uid),
                  ),
                ),
                if (offer?.status == OfferStatus.completed)
                  _ReviewPrompt(conversation: c, uid: uid),
                _InputBar(
                  controller: _input,
                  hint: l.typeMessage,
                  onSend: _send,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _menu(Conversation c, bool active) {
    final l = context.l10n;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu_rounded, color: AppColors.ink),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (v) {
        switch (v) {
          case 'product':
            if (c.productId != null) context.push(AppRoutes.product(c.productId!));
          case 'complete':
            _dealAction(c, complete: true);
          case 'cancel':
            _dealAction(c, complete: false);
        }
      },
      itemBuilder: (_) => [
        if (c.productId != null)
          PopupMenuItem(value: 'product', child: Text(l.viewProduct)),
        if (active) ...[
          PopupMenuItem(value: 'complete', child: Text(l.confirmComplete)),
          PopupMenuItem(
              value: 'cancel',
              child: Text(l.cancelDeal,
                  style: const TextStyle(color: AppColors.error))),
        ],
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.city,
    required this.avatarUrl,
    required this.showCall,
    required this.onCall,
    required this.onBack,
    required this.menu,
  });

  final String name;
  final String city;
  final String? avatarUrl;
  final bool showCall;
  final VoidCallback onCall;
  final VoidCallback onBack;
  final Widget menu;

  @override
  Widget build(BuildContext context) {
    // RTL order (start→end): menu, call, name, avatar, back. In LTR the back
    // button stays on the physical left, so the list is simply reversed.
    final children = <Widget>[
      menu,
      if (showCall)
        IconButton(
          onPressed: onCall,
          tooltip: context.l10n.callPeer,
          icon: const Icon(Icons.phone_outlined, color: AppColors.forestGreen),
        ),
      Expanded(
        child: Column(
          children: [
            Text(name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sectionTitle.copyWith(fontSize: 20)),
            if (city.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.forestGreen),
                  const SizedBox(width: 4),
                  Text(city,
                      style: AppText.captionMuted
                          .copyWith(color: AppColors.forestGreen)),
                ],
              ),
          ],
        ),
      ),
      Avatar(name: name, url: avatarUrl, size: 48),
      BackChevron(onTap: onBack),
    ];
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 10, 8, 10),
      child: Row(children: context.isRtl ? children : children.reversed.toList()),
    );
  }
}

/// Builds banner + details card + day separators + bubbles (newest at bottom).
class _MessageList extends StatelessWidget {
  const _MessageList(
      {required this.conversation, required this.messages, required this.uid});
  final Conversation conversation;
  final List<Message> messages;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final offer = conversation.offer;

    String dayLabel(DateTime d) {
      final now = DateTime.now();
      return Fmt.sameDay(d, now)
          ? l.today
          : Fmt.sameDay(d, now.subtract(const Duration(days: 1)))
              ? l.yesterday
              : Fmt.date(d, lang);
    }

    final items = <Widget>[];
    DateTime? lastDay;
    if (offer != null) {
      final banner = _banner(context, offer);
      if (banner != null) items.add(banner);
      // Like the design: banner, day chip, then the swap-details card.
      if (messages.isNotEmpty) {
        lastDay = messages.first.createdAt.toLocal();
        items.add(_DayChip(label: dayLabel(lastDay)));
      }
      items.add(_DetailsCard(offer: offer));
    }

    for (final m in messages) {
      final d = m.createdAt.toLocal();
      if (lastDay == null || !Fmt.sameDay(lastDay, d)) {
        items.add(_DayChip(label: dayLabel(d)));
        lastDay = d;
      }
      items.add(_Bubble(message: m, mine: m.senderId == uid));
    }

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsetsDirectional.fromSTEB(
          AppRadius.screenPadding, 14, AppRadius.screenPadding, 8),
      itemCount: items.length,
      itemBuilder: (_, i) => items[items.length - 1 - i],
    );
  }

  Widget? _banner(BuildContext context, Offer offer) {
    final l = context.l10n;
    final (text, bg, fg) = switch (offer.status) {
      OfferStatus.accepted => (
          offer.isSwap ? l.dealAcceptedSwap : l.dealAcceptedBuy,
          AppColors.citrus,
          AppColors.deepPine
        ),
      OfferStatus.completed => (
          l.dealCompleted,
          AppColors.softMint,
          AppColors.forestGreen
        ),
      OfferStatus.cancelled => (
          l.dealCancelled,
          AppColors.warmPeach,
          AppColors.peachText
        ),
      _ => (null, null, null),
    };
    if (text == null) return null;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text,
          style: AppText.sectionTitle.copyWith(color: fg, fontSize: 17)),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(label, style: AppText.captionMuted),
        ),
      );
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.offer});
  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget item(ProductMini? p) => Expanded(
          child: InkWell(
            onTap: p == null ? null : () => context.push(AppRoutes.product(p.id)),
            borderRadius: BorderRadius.circular(14),
            child: Row(
              children: [
                SizedBox(width: 56, child: ProductImage(url: p?.cover, radius: 12)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(p?.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.caption.copyWith(fontSize: 13)),
                ),
              ],
            ),
          ),
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(offer.isSwap ? l.swapDetails : l.buyDetails,
              style: AppText.cardTitle.copyWith(color: AppColors.forestGreen)),
          const SizedBox(height: 12),
          Row(
            children: [
              item(offer.product),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                    offer.isSwap
                        ? Icons.swap_horiz_rounded
                        : Icons.arrow_forward_rounded,
                    color: AppColors.forestGreen),
              ),
              if (offer.isSwap)
                item(offer.offered)
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.offerBuyLabel, style: AppText.cardTitle),
                      Text(Fmt.price(offer.cashAmount, context.lang),
                          style: AppText.price.copyWith(fontSize: 15)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine});
  final Message message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final lang = context.lang;
    final time = Fmt.time(message.createdAt, lang);
    final read = message.readAt != null;
    final maxW = MediaQuery.sizeOf(context).width * 0.75;

    return Align(
      alignment:
          mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: Column(
            crossAxisAlignment:
                mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 14, 18, 10),
                decoration: BoxDecoration(
                  color: mine ? AppColors.forestGreen : AppColors.bubbleOther,
                  borderRadius: BorderRadius.circular(AppRadius.bubble),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message.body,
                        style: AppText.body.copyWith(
                            fontSize: 15,
                            height: 1.5,
                            color: mine ? Colors.white : AppColors.ink)),
                    if (mine) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.done_all_rounded,
                              size: 16,
                              color: Colors.white
                                  .withValues(alpha: read ? 1 : 0.45)),
                          const SizedBox(width: 4),
                          Text(time,
                              style: AppText.captionMuted.copyWith(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (!mine)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(time,
                      style: AppText.captionMuted.copyWith(fontSize: 11)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar(
      {required this.controller, required this.hint, required this.onSend});
  final TextEditingController controller;
  final String hint;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  style: AppText.body,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle:
                        AppText.body.copyWith(color: AppColors.textMuted),
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.canvas,
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 20, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      borderSide: const BorderSide(
                          color: AppColors.forestGreen, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onSend,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                      color: AppColors.forestGreen, shape: BoxShape.circle),
                  child: Icon(Icons.send_rounded,
                      color: Colors.white,
                      textDirection: TextDirection.ltr,
                      size: 24),
                ),
              ),
            ],
          ),
        ),
      );
}

class _ReviewPrompt extends ConsumerWidget {
  const _ReviewPrompt({required this.conversation, required this.uid});
  final Conversation conversation;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final offerId = conversation.offerId;
    if (offerId == null) return const SizedBox.shrink();
    final reviewed = ref.watch(hasReviewedProvider(offerId)).valueOrNull;
    if (reviewed != false) return const SizedBox.shrink();
    final peer = conversation.peerOf(uid);

    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softMint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.star, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Text(l.rateExperience(peer?.fullName ?? ''),
                style: AppText.label.copyWith(color: AppColors.deepPine)),
          ),
          const SizedBox(width: 8),
          AppButton(
            label: l.rateNow,
            expand: false,
            height: 40,
            fontSize: 13,
            onPressed: () async {
              final ok = await showReviewSheet(
                context,
                offerId: offerId,
                revieweeId: conversation.peerIdOf(uid),
                revieweeName: peer?.fullName ?? '',
              );
              if (ok) ref.invalidate(hasReviewedProvider(offerId));
            },
          ),
        ],
      ),
    );
  }
}
