import 'package:book_cover_designer_flutter/services/cover_font_registry.dart';
import 'package:book_cover_designer_flutter/services/cover_fonts.dart';
import 'package:flutter/material.dart';

class CoverFontPreview {
  CoverFontPreview._();

  static TextStyle textStyle({
    required String fontKey,
    TextStyle? base,
    Color? clearColor,
  }) {
    base ??= const TextStyle(fontSize: 16);

    if (fontKey == 'Clear') {
      return base.copyWith(
        fontFamily: null,
        color: clearColor ?? Colors.red,
      );
    }

    if (CoverFonts.isCustomKey(fontKey) ||
        CoverFontRegistry.builtInAssetMap.containsKey(fontKey)) {
      return base.copyWith(fontFamily: fontKey);
    }

    return base;
  }
}
