import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/l10n_labels.dart';
import 'page_header.dart';

/// Shown instead of the app when SUPABASE_URL / SUPABASE_ANON_KEY are missing.
class ConfigErrorScreen extends StatelessWidget {
  const ConfigErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppRadius.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoBox(size: 96),
              const SizedBox(height: 24),
              const Icon(Icons.settings_suggest_outlined,
                  size: 44, color: AppColors.error),
              const SizedBox(height: 12),
              Text(l.configMissingTitle,
                  textAlign: TextAlign.center, style: AppText.sectionTitle),
              const SizedBox(height: 8),
              Text(l.configMissingBody,
                  textAlign: TextAlign.center, style: AppText.bodyMuted),
            ],
          ),
        ),
      ),
    );
  }
}
