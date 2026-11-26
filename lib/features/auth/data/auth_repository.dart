import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/supabase/supabase_provider.dart';
import '../../../l10n/app_localizations.dart';

enum AuthError { invalidCredentials, emailTaken, invalidCode, network, generic }

class AuthFailure implements Exception {
  const AuthFailure(this.error);
  final AuthError error;

  String message(AppLocalizations l) => switch (error) {
        AuthError.invalidCredentials => l.errInvalidCredentials,
        AuthError.emailTaken => l.errEmailTaken,
        AuthError.invalidCode => l.errInvalidCode,
        AuthError.network => l.errNetwork,
        AuthError.generic => l.errorGeneric,
      };
}

const _kRememberKey = 'remember_me';

class AuthRepository {
  AuthRepository(this._client, this._prefs);
  final SupabaseClient _client;
  final SharedPreferences _prefs;

  bool get rememberMe => _prefs.getBool(_kRememberKey) ?? true;
  Session? get session => _client.auth.currentSession;

  Future<T> _guard<T>(Future<T> Function() run,
      {AuthError onAuth = AuthError.generic}) async {
    try {
      return await run();
    } on AuthException catch (e) {
      final m = e.message.toLowerCase();
      if (m.contains('invalid login') || m.contains('invalid credentials')) {
        throw const AuthFailure(AuthError.invalidCredentials);
      }
      if (m.contains('already registered') || m.contains('already exists')) {
        throw const AuthFailure(AuthError.emailTaken);
      }
      if (m.contains('token') || m.contains('expired') || m.contains('otp')) {
        throw const AuthFailure(AuthError.invalidCode);
      }
      throw AuthFailure(onAuth);
    } on SocketException {
      throw const AuthFailure(AuthError.network);
    } on HttpException {
      throw const AuthFailure(AuthError.network);
    }
  }

  Future<void> signIn(
      {required String email,
      required String password,
      required bool remember}) async {
    await _guard(() =>
        _client.auth.signInWithPassword(email: email.trim(), password: password));
    await _prefs.setBool(_kRememberKey, remember);
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String city,
    required String address,
  }) async {
    await _guard(() => _client.auth.signUp(
          email: email.trim(),
          password: password,
          data: {
            'full_name': fullName.trim(),
            'phone': phone.trim(),
            'city': city,
            'address': address.trim(),
          },
        ));
    await _prefs.setBool(_kRememberKey, true);
  }

  Future<void> signOut() => _client.auth.signOut();

  /// Called on app start: honours an unchecked "remember me".
  Future<void> enforceRememberMe() async {
    if (session != null && !rememberMe) await signOut();
  }

  Future<void> sendResetCode(String email) =>
      _guard(() => _client.auth.resetPasswordForEmail(email.trim()));

  /// Verifies the recovery OTP (signs the user in) then sets the new password.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _guard(() => _client.auth.verifyOTP(
          type: OtpType.recovery,
          email: email.trim(),
          token: code.trim(),
        ));
    await _guard(
        () => _client.auth.updateUser(UserAttributes(password: newPassword)));
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) =>
    AuthRepository(ref.watch(supabaseProvider), ref.watch(sharedPrefsProvider)));
