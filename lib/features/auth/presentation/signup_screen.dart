import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/governorates.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../data/auth_repository.dart';
import '../data/validators.dart';
import 'auth_scaffold.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  String? _city;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _phone, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).signUp(
            email: _email.text,
            password: _password.text,
            fullName: _name.text,
            phone: _phone.text,
            city: _city!,
            address: _address.text,
          );
      // Router redirect moves us to /home (email confirmation is off).
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message(context.l10n));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    const gap = SizedBox(height: 16);
    return AuthScaffold(
      title: l.signupTitle,
      subtitle: l.signupSubtitle,
      logoSize: 150,
      form: Form(
        key: _form,
        child: Column(
          children: [
            AppTextField(
              label: l.fullName,
              hint: l.fullNameHint,
              controller: _name,
              icon: Icons.person_rounded,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: Validators.name(l),
            ),
            gap,
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
            gap,
            AppTextField(
              label: l.password,
              hint: l.passwordHint,
              controller: _password,
              icon: Icons.lock_rounded,
              obscure: true,
              textInputAction: TextInputAction.next,
              validator: Validators.password(l),
            ),
            gap,
            AppTextField(
              label: l.phone,
              hint: l.phoneHint,
              controller: _phone,
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              maxLength: 11,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.phone(l),
            ),
            gap,
            AppDropdownField<String>(
              label: l.governorate,
              hint: l.selectGovernorate,
              icon: Icons.location_city_rounded,
              value: _city,
              items: [
                for (final g in governorates)
                  DropdownMenuItem(value: g.ar, child: Text(g.name(lang))),
              ],
              onChanged: (v) => setState(() => _city = v),
              validator: (v) => v == null ? l.errRequired : null,
            ),
            gap,
            AppTextField(
              label: l.address,
              hint: l.addressHint,
              controller: _address,
              icon: Icons.location_on_rounded,
              textInputAction: TextInputAction.done,
              validator: Validators.required(l),
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
          ],
        ),
      ),
      bottom: Column(
        children: [
          AppButton(
              label: l.createAccount, onPressed: _submit, loading: _loading),
          const SizedBox(height: 24),
          AuthSwitchLink(
            text: l.haveAccount,
            action: l.loginNow,
            onTap: () => context.go(AppRoutes.login),
          ),
        ],
      ),
    );
  }
}
