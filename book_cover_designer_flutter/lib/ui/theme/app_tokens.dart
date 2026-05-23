/// Spacing scale (8pt-ish system + fine-grained).
class AppSpacing {
  const AppSpacing();

  // micro
  static const double xxs = 4;
  static const double xs = 8;

  // base
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;

  // large
  static const double xl = 32;
  static const double xxl = 40;
  static const double xxxl = 56;
}

/// Corner radius scale.
class AppRadii {
  const AppRadii();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;
}

/// Optional: Elevation scale if you want it consistent.
class AppElevation {
  const AppElevation();

  static const double none = 0;
  static const double low = 1;
  static const double mid = 3;
  static const double high = 6;
}
