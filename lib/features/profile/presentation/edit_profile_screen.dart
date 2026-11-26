import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/governorates.dart';
import '../../../core/supabase/supabase_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/l10n_labels.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/avatar.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/states.dart';
import '../../auth/data/validators.dart';
import '../../products/data/product_repository.dart';
import '../data/profile_repository.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(myProfileProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: l.editProfileTitle,
              showLogo: false,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: AsyncView(
                value: async,
                onRetry: () => ref.invalidate(myProfileProvider),
                data: (p) => _Form(profile: p),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({required this.profile});
  final MyProfile profile;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile.base.fullName);
  late final _phone = TextEditingController(text: widget.profile.phone ?? '');
  late final _address =
      TextEditingController(text: widget.profile.address ?? '');
  late String? _city = governorates.any((g) => g.ar == widget.profile.base.city)
      ? widget.profile.base.city
      : null;
  late String? _avatarUrl = widget.profile.base.avatarUrl;
  bool _saving = false;
  bool _uploading = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _pickAvatar() async {
    try {
      final f = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (f == null) return;
      setState(() => _uploading = true);
      final url = await ref
          .read(productRepositoryProvider)
          .uploadImage(f, bucket: 'avatars');
      if (mounted) setState(() => _avatarUrl = url);
    } catch (_) {
      if (mounted) _snack(context.l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(profileRepositoryProvider).updateMine(
            fullName: _name.text,
            phone: _phone.text,
            city: _city!,
            address: _address.text,
            avatarUrl: _avatarUrl,
          );
      final uid = ref.read(currentUserIdProvider);
      ref.invalidate(myProfileProvider);
      if (uid != null) ref.invalidate(profileProvider(uid));
      if (!mounted) return;
      _snack(context.l10n.profileSaved);
      context.pop();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        _snack(context.l10n.errorGeneric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(
            AppRadius.screenPadding, 16, AppRadius.screenPadding, 24),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Avatar(name: _name.text, url: _avatarUrl, size: 104),
                    if (_uploading) const CircularProgressIndicator(),
                  ],
                ),
                TextButton.icon(
                  onPressed: _uploading ? null : _pickAvatar,
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: Text(l.changePhoto,
                      style: AppText.label
                          .copyWith(color: AppColors.forestGreen)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AppTextField(
            style: AppFieldStyle.bordered,
            label: l.fullName,
            controller: _name,
            validator: Validators.name(l),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          AppTextField(
            style: AppFieldStyle.bordered,
            label: l.phone,
            hint: l.phoneHint,
            controller: _phone,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.phone(l),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          AppDropdownField<String>(
            style: AppFieldStyle.bordered,
            label: l.governorate,
            hint: l.selectGovernorate,
            value: _city,
            items: [
              for (final g in governorates)
                DropdownMenuItem(value: g.ar, child: Text(g.name(lang))),
            ],
            onChanged: (v) => setState(() => _city = v),
            validator: (v) => v == null ? l.errRequired : null,
          ),
          const SizedBox(height: 14),
          AppTextField(
            style: AppFieldStyle.bordered,
            label: l.address,
            controller: _address,
            validator: Validators.required(l),
          ),
          const SizedBox(height: 24),
          AppButton(label: l.save, onPressed: _save, loading: _saving),
        ],
      ),
    );
  }
}
