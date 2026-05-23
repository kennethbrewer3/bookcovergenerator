import 'package:flutter/material.dart';
import 'app_tokens.dart';

/// A ThemeExtension that carries app-specific design tokens.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.spacing,
    required this.radii,
    required this.elevation,
  });

  final AppSpacing spacing;
  final AppRadii radii;
  final AppElevation elevation;

  /// Light tokens (can differ from dark later if you want).
  static const AppTokens light = AppTokens(
    spacing: AppSpacing(),
    radii: AppRadii(),
    elevation: AppElevation(),
  );

  /// Dark tokens (same for now; customize freely).
  static const AppTokens dark = AppTokens(
    spacing: AppSpacing(),
    radii: AppRadii(),
    elevation: AppElevation(),
  );

  @override
  AppTokens copyWith({
    AppSpacing? spacing,
    AppRadii? radii,
    AppElevation? elevation,
  }) {
    return AppTokens(
      spacing: spacing ?? this.spacing,
      radii: radii ?? this.radii,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    // These are discrete tokens; no meaningful interpolation needed.
    if (other is! AppTokens) return this;
    return t < 0.5 ? this : other;
  }
}

/// Convenience accessor
extension AppTokensX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>() ?? AppTokens.light;
}
