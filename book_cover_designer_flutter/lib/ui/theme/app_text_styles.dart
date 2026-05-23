import 'package:flutter/material.dart';

/// App-level text style presets (separate from ThemeData).
/// These styles derive colors from the active theme (light/dark).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextStyle(
      color: scheme.onSurface,
      height: 1.2,
    );
  }

  // Headlines
  static TextStyle h1(BuildContext context) => _base(context).copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    height: 1.1,
  );

  static TextStyle h2(BuildContext context) => _base(context).copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  static TextStyle h3(BuildContext context) => _base(context).copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  // Body
  static TextStyle body(BuildContext context) => _base(context).copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static TextStyle bodyMuted(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return body(context).copyWith(
      color: scheme.onSurfaceVariant,
    );
  }

  // Labels / buttons
  static TextStyle button(BuildContext context) => _base(context).copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static TextStyle caption(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _base(context).copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: scheme.onSurfaceVariant,
      height: 1.25,
    );
  }
}
