import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../profile/data/profile_repository.dart';

/// Returns true when the review was submitted.
Future<bool> showReviewSheet(
  BuildContext context, {
  required String offerId,
  required String revieweeId,
  required String revieweeName,
}) async {
  final done = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReviewSheet(
        offerId: offerId, revieweeId: revieweeId, revieweeName: revieweeName),
  );
  return done ?? false;
}

class _ReviewSheet extends ConsumerStatefulWidget {
  const _ReviewSheet({
    required this.offerId,
    required this.revieweeId,
    required this.revieweeName,
  });
  final String offerId;
  final String revieweeId;
  final String revieweeName;

  @override
  ConsumerState<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<_ReviewSheet> {
  final _comment = TextEditingController();
  int _rating = 0;
  bool _loading = false;
  bool _showError = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      setState(() => _showError = true);
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(profileRepositoryProvider).submitReview(
            offerId: widget.offerId,
            revieweeId: widget.revieweeId,
            rating: _rating,
            comment: _comment.text,
          );
      ref.invalidate(profileProvider(widget.revieweeId));
      ref.invalidate(reviewsProvider(widget.revieweeId));
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.reviewSent)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.rateExperience(widget.revieweeName),
                textAlign: TextAlign.center, style: AppText.sectionTitle),
            const SizedBox(height: 16),
            RatingStars(
              rating: _rating.toDouble(),
              size: 42,
              spacing: 4,
              onChanged: (v) => setState(() {
                _rating = v;
                _showError = false;
              }),
            ),
            if (_showError)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(l.errChooseRating,
                    style: AppText.captionMuted
                        .copyWith(color: AppColors.error)),
              ),
            const SizedBox(height: 16),
            AppTextField(
              style: AppFieldStyle.bordered,
              hint: l.writeComment,
              controller: _comment,
              minLines: 3,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            AppButton(
                label: l.submitReview, onPressed: _submit, loading: _loading),
          ],
        ),
      ),
    );
  }
}
