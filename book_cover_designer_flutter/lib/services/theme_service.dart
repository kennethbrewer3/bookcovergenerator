import 'package:book_cover_designer_flutter/ui/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _key = 'app_theme_variant';

  final ValueNotifier<AppThemeVariant> variant;
  final SharedPreferencesWithCache _prefs;

  ThemeService._(this.variant, this._prefs);

  static Future<ThemeService> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    final saved = prefs.getString(_key);
    debugPrint('[ThemeService] loaded key="$saved"');
    final initial = AppThemeVariant.values.firstWhere(
      (v) => v.name == saved,
      orElse: () => AppThemeVariant.light,
    );
    return ThemeService._(ValueNotifier(initial), prefs);
  }

  Future<void> setVariant(AppThemeVariant v) async {
    variant.value = v;
    await _prefs.setString(_key, v.name);
    debugPrint('[ThemeService] saved key="${v.name}"');
  }

  ThemeData get themeData => AppTheme.forVariant(variant.value);
}
