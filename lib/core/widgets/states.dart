import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/l10n_labels.dart';
import 'app_button.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                    color: AppColors.softMint, shape: BoxShape.circle),
                child: Icon(icon, size: 40, color: AppColors.forestGreen),
              ),
              const SizedBox(height: 16),
              Text(title,
                  textAlign: TextAlign.center, style: AppText.sectionTitle),
              if (message != null) ...[
                const SizedBox(height: 6),
                Text(message!,
                    textAlign: TextAlign.center, style: AppText.bodyMuted),
              ],
              if (actionLabel != null) ...[
                const SizedBox(height: 20),
                AppButton(
                  label: actionLabel!,
                  onPressed: onAction,
                  expand: false,
                ),
              ],
            ],
          ),
        ),
      );
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(message ?? context.l10n.errorGeneric,
                  textAlign: TextAlign.center, style: AppText.bodyMuted),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                AppButton(
                  label: context.l10n.retry,
                  onPressed: onRetry,
                  variant: AppButtonVariant.mint,
                  expand: false,
                ),
              ],
            ],
          ),
        ),
      );
}

/// Renders loading / error (with retry) / data for an [AsyncValue].
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? loading;

  @override
  Widget build(BuildContext context) => value.when(
        data: data,
        loading: () => loading ?? const LoadingState(),
        error: (e, _) => ErrorState(onRetry: onRetry),
      );
}
