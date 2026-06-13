import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported locales with display metadata.
class AppLocaleOption {
  const AppLocaleOption({
    required this.locale,
    required this.label,
    required this.flag,
  });

  final Locale locale;
  final String label;
  final String flag;

  static const List<AppLocaleOption> all = [
    AppLocaleOption(locale: Locale('en'), label: 'English', flag: '🇺🇸'),
    AppLocaleOption(locale: Locale('es'), label: 'Español', flag: '🇪🇸'),
    AppLocaleOption(locale: Locale('fr'), label: 'Français', flag: '🇫🇷'),
  ];

  static AppLocaleOption forLocale(Locale locale) => all.firstWhere(
        (o) => o.locale.languageCode == locale.languageCode,
        orElse: () => all.first,
      );
}

class LocaleService {
  static const _key = 'app_locale';

  final ValueNotifier<Locale> locale;
  final SharedPreferencesWithCache _prefs;

  LocaleService._(this.locale, this._prefs);

  static Future<LocaleService> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    final saved = prefs.getString(_key);
    final initial = saved != null
        ? Locale(saved)
        : const Locale('en');
    return LocaleService._(ValueNotifier(initial), prefs);
  }

  Future<void> setLocale(Locale l) async {
    locale.value = l;
    await _prefs.setString(_key, l.languageCode);
  }
}
