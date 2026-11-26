import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/page_header.dart';
import 'conversations_tab.dart';
import '../../offers/presentation/offers_tab.dart';

/// "رسائلي" tab: segmented control → conversations | offers.
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        PageHeader(title: l.messagesTitle, subtitle: l.messagesSubtitle),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              AppRadius.screenPadding, 0, AppRadius.screenPadding, 12),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.button + 2),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                _Seg(
                    label: l.tabConversations,
                    selected: _tab == 0,
                    onTap: () => setState(() => _tab = 0)),
                _Seg(
                    label: l.tabOffers,
                    selected: _tab == 1,
                    onTap: () => setState(() => _tab = 1)),
              ],
            ),
          ),
        ),
        Expanded(
          child: _tab == 0
              ? const ConversationsTab()
              : const OffersTab(),
        ),
      ],
    );
  }
}

class _Seg extends StatelessWidget {
  const _Seg({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.softMint : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.button - 2),
            ),
            child: Text(label,
                style: AppText.label.copyWith(
                    fontSize: 14,
                    color:
                        selected ? AppColors.forestGreen : AppColors.textMuted,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600)),
          ),
        ),
      );
}
