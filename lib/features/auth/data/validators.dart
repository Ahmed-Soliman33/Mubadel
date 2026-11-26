import '../../../l10n/app_localizations.dart';

class Validators {
  const Validators._();

  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phone = RegExp(r'^01[0125][0-9]{8}$');

  static String? Function(String?) email(AppLocalizations l) =>
      (v) => v != null && _email.hasMatch(v.trim()) ? null : l.errEmailInvalid;

  static String? Function(String?) password(AppLocalizations l) =>
      (v) => v != null && v.length >= 6 ? null : l.errPasswordShort;

  static String? Function(String?) name(AppLocalizations l) =>
      (v) => v != null && v.trim().length >= 3 ? null : l.errNameShort;

  static String? Function(String?) phone(AppLocalizations l) =>
      (v) => v != null && _phone.hasMatch(v.trim()) ? null : l.errPhoneInvalid;

  static String? Function(String?) required(AppLocalizations l) =>
      (v) => v != null && v.trim().isNotEmpty ? null : l.errRequired;
}
