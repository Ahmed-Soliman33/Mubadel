import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/l10n_labels.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.index,
    required this.onTap,
    this.messagesBadge = 0,
  });

  final int index;
  final ValueChanged<int> onTap;
  final int messagesBadge;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      (Icons.home_outlined, Icons.home_rounded, l.navHome, 0),
      (Icons.favorite_border_rounded, Icons.favorite_rounded, l.navFavorites, 0),
      (Icons.add_rounded, Icons.add_rounded, l.navAdd, 0),
      (Icons.table_rows_outlined, Icons.table_rows_rounded, l.navMessages,
          messagesBadge),
      (Icons.radio_button_checked_rounded, Icons.radio_button_checked_rounded,
          l.navProfile, 0),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavItem(
                      icon: i == index ? items[i].$2 : items[i].$1,
                      label: items[i].$3,
                      badge: items[i].$4,
                      active: i == index,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.badge,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int badge;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.forestGreen
        : AppColors.ink.withValues(alpha: 0.7);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(minWidth: 64),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: active ? AppColors.softMint : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 28, color: color),
                  if (badge > 0)
                    PositionedDirectional(
                      top: -4,
                      end: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        constraints: const BoxConstraints(minWidth: 18),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          badge > 99 ? '99+' : '$badge',
                          textAlign: TextAlign.center,
                          style: AppText.caption
                              .copyWith(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(
                  fontSize: 11,
                  color: color,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
