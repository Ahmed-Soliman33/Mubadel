import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../data/auth_repository.dart';
import '../data/validators.dart';
import 'auth_scaffold.dart';

/// Step 1: email → send OTP. Step 2: code + new password → verify & update.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _codeSent = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_email, _code, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_form.currentState!.validate()) return;
    final repo = ref.read(authRepositoryProvider);
    setState(() => _loading = true);
    try {
      if (!_codeSent) {
        await repo.sendResetCode(_email.text);
        if (mounted) setState(() => _codeSent = true);
      } else {
        await repo.resetPassword(
          email: _email.text,
          code: _code.text,
          newPassword: _password.text,
        );
        if (mounted) context.go(AppRoutes.home);
      }
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message(context.l10n));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final step2 = _codeSent;
    return AuthScaffold(
      title: step2 ? l.resetTitle : l.forgotTitle,
      subtitle:
          step2 ? l.resetSubtitle(_email.text.trim()) : l.forgotSubtitle,
      logoSize: 150,
      onBack: () => context.canPop() ? context.pop() : context.go(AppRoutes.login),
      form: Form(
        key: _form,
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (!step2)
              AppTextField(
                label: l.email,
                hint: l.emailHint,
                controller: _email,
                icon: Icons.mail_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: Validators.email(l),
                onSubmitted: (_) => _submit(),
              )
            else ...[
              AppTextField(
                label: l.code,
                hint: l.codeHint,
                controller: _code,
                icon: Icons.pin_rounded,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v != null && v.length == 6 ? null : l.errInvalidCode,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: l.newPassword,
                hint: l.passwordHint,
                controller: _password,
                icon: Icons.lock_rounded,
                obscure: true,
                textInputAction: TextInputAction.next,
                validator: Validators.password(l),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: l.confirmPassword,
                hint: l.passwordHint,
                controller: _confirm,
                icon: Icons.lock_rounded,
                obscure: true,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    v == _password.text ? null : l.errPasswordsMismatch,
                onSubmitted: (_) => _submit(),
              ),
            ],
            if (_error != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 8, start: 2),
                  child: Text(_error!,
                      style: AppText.captionMuted
                          .copyWith(color: AppColors.error)),
                ),
              ),
          ],
        ),
      ),
      bottom: AppButton(
        label: step2 ? l.savePassword : l.sendCode,
        onPressed: _submit,
        loading: _loading,
      ),
    );
  }
}
