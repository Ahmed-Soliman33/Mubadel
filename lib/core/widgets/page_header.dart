import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/l10n_labels.dart';

/// Small white rounded square with the app logo.
class LogoBox extends StatelessWidget {
  const LogoBox({super.key, this.size = 56});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
      );
}

/// Round/rect back chevron that points toward the start side.
class BackChevron extends StatelessWidget {
  const BackChevron({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            context.isRtl
                ? Icons.chevron_right_rounded
                : Icons.chevron_left_rounded,
            size: 30,
            color: AppColors.ink,
          ),
        ),
      );
}

/// Main screen header: title + subtitle at the start, logo (or back button /
/// custom [trailing]) at the end.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
    this.showLogo = true,
    this.titleWidget,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool showLogo;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    // The design keeps the back button on the physical left (end side in
    // RTL, start side in LTR) so it sits at the same corner in both locales.
    final backAtStart = !context.isRtl && onBack != null && trailing == null;
    Widget? end = trailing;
    if (end == null && onBack != null && !backAtStart) {
      end = BackChevron(onTap: onBack!);
    } else if (end == null && onBack == null && showLogo) {
      end = const LogoBox();
    }
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          AppRadius.screenPadding, 12, AppRadius.screenPadding, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (backAtStart) ...[BackChevron(onTap: onBack!), const SizedBox(width: 8)],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget ?? Text(title, style: AppText.pageTitle),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: AppText.pageSubtitle),
                  ],
                ],
              ),
            ),
          ),
          if (end != null) ...[const SizedBox(width: 12), end],
        ],
      ),
    );
  }
}
