import 'package:flutter/material.dart';
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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).signIn(
          email: _email.text, password: _password.text, remember: _remember);
      // Router redirect moves us to /home on the auth state change.
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message(context.l10n));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AuthScaffold(
      title: l.loginTitle,
      subtitle: l.loginSubtitle,
      form: Form(
        key: _form,
        child: Column(
          children: [
            const SizedBox(height: 28),
            AppTextField(
              label: l.email,
              hint: l.emailHint,
              controller: _email,
              icon: Icons.mail_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email(l),
            ),
            const SizedBox(height: 18),
            AppTextField(
              label: l.password,
              hint: l.passwordHint,
              controller: _password,
              icon: Icons.lock_rounded,
              obscure: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: Validators.password(l),
              onSubmitted: (_) => _submit(),
            ),
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
            const SizedBox(height: 10),
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _remember = !_remember),
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: Checkbox(
                          value: _remember,
                          visualDensity: VisualDensity.compact,
                          onChanged: (v) =>
                              setState(() => _remember = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(l.rememberMe,
                          style: AppText.body.copyWith(
                              color: AppColors.forestGreen,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push(AppRoutes.forgot),
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.forestGreen,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 32)),
                  child: Text(l.forgotPassword,
                      style: AppText.body.copyWith(
                          color: AppColors.forestGreen,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: Column(
        children: [
          AppButton(
              label: l.loginButton, onPressed: _submit, loading: _loading),
          const SizedBox(height: 28),
          AuthSwitchLink(
            text: l.noAccount,
            action: l.signUpNow,
            onTap: () => context.go(AppRoutes.signup),
          ),
        ],
      ),
    );
  }
}
