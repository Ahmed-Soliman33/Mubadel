import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'locale';

/// Overridden in `main()` with the real instance.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPrefsProvider not overridden'),
);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final code = ref.read(sharedPrefsProvider).getString(_kLocaleKey);
    return Locale(code == 'en' ? 'en' : 'ar');
  }

  Future<void> set(Locale locale) async {
    state = locale;
    await ref.read(sharedPrefsProvider).setString(_kLocaleKey, locale.languageCode);
  }

  Future<void> toggle() =>
      set(Locale(state.languageCode == 'ar' ? 'en' : 'ar'));
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
