import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/page_header.dart';

/// Shared layout for Login / Signup / Forgot: header, centered logo, form,
/// and a bottom area pinned to the end of the screen.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    required this.bottom,
    this.logoSize = 190,
    this.onBack,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final Widget bottom;
  final double logoSize;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PageHeader(
                    title: title,
                    subtitle: subtitle,
                    showLogo: false,
                    onBack: onBack),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 26),
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png',
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.contain),
                      form,
                      const Spacer(),
                      const SizedBox(height: 24),
                      bottom,
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

/// "Have an account? / [Log in]" block under the main button.
class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({super.key, required this.text, required this.action, required this.onTap});

  final String text;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted)),
          const SizedBox(height: 10),
          Material(
            color: AppColors.softMint,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
                child: Text(action,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestGreen)),
              ),
            ),
          ),
        ],
      );
}
