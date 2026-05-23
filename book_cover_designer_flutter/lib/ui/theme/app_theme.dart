// lib/theme/app_tokens.dart
import 'package:flutter/material.dart';

/// Centralized app palette. Update values here to retheme the whole app.
class AppColors {
  AppColors._();

  // Brand (forest green base)
  static const Color brand = Color(0xFF228B22);

  // Light neutrals / surfaces
  static const Color background = Color(0xFFF6F7F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE9EEE6);

  // Light text
  static const Color textPrimary = Color(0xFF0F1A10);
  static const Color textSecondary = Color(0xFF3B4A3D);

  // Accents
  static const Color accent = Color(0xFF3FA34D);
  static const Color highlight = Color(0xFFD7F2D8);

  // Status
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFB00020);
  static const Color info = Color(0xFF2563EB);

  // Borders
  static const Color border = Color(0xFFCBD5C0);

  // Dark neutrals / surfaces
  static const Color backgroundDark = Color(0xFF0B120C);
  static const Color surfaceDark = Color(0xFF101A12);
  static const Color surfaceVariantDark = Color(0xFF17271B);

  // Dark text
  static const Color textPrimaryDark = Color(0xFFEAF2EA);
  static const Color textSecondaryDark = Color(0xFFB9C7BB);

  // Dark borders
  static const Color borderDark = Color(0xFF2A3A2D);
}

/// App theme builder (Flutter 3.22+ / Material 3 friendly).
class AppTheme {
  AppTheme._();

  static const double _radius = 14.0;
  static const double _borderWidth = 1.2;

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.light,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,

      // Typography
      textTheme: _textTheme(Brightness.light),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),

      // Cards (Flutter 3.22+ uses CardThemeData)
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0.5,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(
            color: AppColors.border.withValues(alpha: 0.60),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: AppColors.border.withValues(alpha: 0.90),
        thickness: 1,
        space: 1,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        errorStyle: const TextStyle(height: 1.2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: _outlineBorder(AppColors.border),
        enabledBorder: _outlineBorder(AppColors.border),
        focusedBorder: _outlineBorder(scheme.primary, width: 1.6),
        errorBorder: _outlineBorder(scheme.error),
        focusedErrorBorder: _outlineBorder(scheme.error, width: 1.6),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.primary.withValues(alpha: 0.35),
          disabledForegroundColor: scheme.onPrimary.withValues(alpha: 0.70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: const BorderSide(color: AppColors.border, width: _borderWidth),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.highlight,
        disabledColor: AppColors.surfaceVariant.withValues(alpha: 0.70),
        labelStyle: const TextStyle(color: AppColors.textPrimary),
        secondaryLabelStyle: const TextStyle(color: AppColors.textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: AppColors.border.withValues(alpha: 0.80)),
        ),
      ),

      // Dialogs / sheets (Flutter 3.22+ uses *ThemeData classes already)
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: AppColors.border.withValues(alpha: 0.70)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: scheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.dark,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ).copyWith(
      surfaceContainerHighest: AppColors.surfaceVariantDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      textTheme: _textTheme(Brightness.dark),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0.5,
        shadowColor: Colors.black.withValues(alpha: 0.25),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(
            color: AppColors.borderDark.withValues(alpha: 0.90),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(8),
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.borderDark.withValues(alpha: 0.90),
        thickness: 1,
        space: 1,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
        hintStyle: const TextStyle(color: AppColors.textSecondaryDark),
        errorStyle: const TextStyle(height: 1.2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: _outlineBorder(AppColors.borderDark),
        enabledBorder: _outlineBorder(AppColors.borderDark),
        focusedBorder: _outlineBorder(scheme.primary, width: 1.6),
        errorBorder: _outlineBorder(scheme.error),
        focusedErrorBorder: _outlineBorder(scheme.error, width: 1.6),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.primary.withValues(alpha: 0.28),
          disabledForegroundColor: scheme.onPrimary.withValues(alpha: 0.65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: const BorderSide(color: AppColors.borderDark, width: _borderWidth),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        selectedColor: AppColors.surfaceVariantDark.withValues(alpha: 0.70),
        disabledColor: AppColors.surfaceVariantDark.withValues(alpha: 0.55),
        labelStyle: const TextStyle(color: AppColors.textPrimaryDark),
        secondaryLabelStyle: const TextStyle(color: AppColors.textPrimaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: AppColors.borderDark.withValues(alpha: 0.80)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: AppColors.borderDark.withValues(alpha: 0.80)),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        contentTextStyle: const TextStyle(color: AppColors.textPrimaryDark),
        actionTextColor: scheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondary =
    isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return TextTheme(
      displayLarge: TextStyle(color: primary, fontWeight: FontWeight.w800),
      displayMedium: TextStyle(color: primary, fontWeight: FontWeight.w800),
      displaySmall: TextStyle(color: primary, fontWeight: FontWeight.w800),

      headlineLarge: TextStyle(color: primary, fontWeight: FontWeight.w800),
      headlineMedium: TextStyle(color: primary, fontWeight: FontWeight.w800),
      headlineSmall: TextStyle(color: primary, fontWeight: FontWeight.w800),

      titleLarge: TextStyle(color: primary, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: primary, fontWeight: FontWeight.w700),
      titleSmall: TextStyle(color: primary, fontWeight: FontWeight.w700),

      bodyLarge: TextStyle(color: primary),
      bodyMedium: TextStyle(color: primary),
      bodySmall: TextStyle(color: secondary),

      labelLarge: TextStyle(color: primary, fontWeight: FontWeight.w700),
      labelMedium: TextStyle(color: primary, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(color: secondary, fontWeight: FontWeight.w600),
    );
  }

  static OutlineInputBorder _outlineBorder(Color color, {double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide(
        color: color,
        width: width ?? _borderWidth,
      ),
    );
  }
}
