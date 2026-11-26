import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/page_header.dart';
import '../../auth/data/auth_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.logout, style: AppText.sectionTitle),
        content: Text(l.logoutConfirm, style: AppText.body),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.logout,
                  style: const TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(authRepositoryProvider).signOut();
      // Router redirect sends the user to /login.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locale = ref.watch(localeProvider);

    Widget tile(IconData icon, String label, VoidCallback onTap,
            {Color color = AppColors.ink, bool chevron = true}) =>
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(icon,
                        color: color == AppColors.ink
                            ? AppColors.forestGreen
                            : color),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(label,
                            style: AppText.cardTitle.copyWith(color: color))),
                    if (chevron)
                      Icon(
                          context.isRtl
                              ? Icons.chevron_left_rounded
                              : Icons.chevron_right_rounded,
                          color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ),
        );

    Widget langChip(String label, Locale value) {
      final selected = locale.languageCode == value.languageCode;
      return Expanded(
        child: GestureDetector(
          onTap: () => ref.read(localeProvider.notifier).set(value),
          child: Container(
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.softMint : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(
                  color: selected ? AppColors.forestGreen : AppColors.border),
            ),
            child: Text(label,
                style: AppText.cardTitle.copyWith(
                    color:
                        selected ? AppColors.forestGreen : AppColors.textMuted)),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: l.settingsTitle,
              subtitle: l.settingsSubtitle,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    AppRadius.screenPadding, 8, AppRadius.screenPadding, 24),
                children: [
                  tile(Icons.person_outline_rounded, l.editProfileTitle,
                      () => context.push(AppRoutes.editProfile)),
                  const SizedBox(height: 14),
                  Text(l.languageLabel, style: AppText.sectionTitle),
                  const SizedBox(height: 10),
                  Row(children: [
                    langChip(l.langArabic, const Locale('ar')),
                    const SizedBox(width: 10),
                    langChip(l.langEnglish, const Locale('en')),
                  ]),
                  const SizedBox(height: 24),
                  tile(Icons.logout_rounded, l.logout,
                      () => _logout(context, ref),
                      color: AppColors.error, chevron: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
