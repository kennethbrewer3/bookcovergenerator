import 'package:book_cover_designer_flutter/models/custom_font.dart';

/// Built-in and user-imported fonts available for cover text.
class CoverFonts {
  CoverFonts._();

  static const builtInItems = <String, String>{
    'Sans Serif': 'sans-serif',
    'Serif': 'serif',
    'Monospace': 'monospace',
    'Ibarra Real Nova': 'ibarra-real-nova',
    'SquarePeg': 'square-peg',
    'Nunito': 'nunito',
    'Pacifico': 'pacifico',
    'Roboto Mono': 'roboto-mono',
  };

  static Map<String, String> fontFamilyItems({
    required String clearLabel,
    Iterable<CustomFont> customFonts = const [],
  }) {
    final items = Map<String, String>.from(builtInItems);
    for (final font in customFonts) {
      items[font.displayName] = font.fontKey;
    }
    items[clearLabel] = 'Clear';
    return items;
  }

  static bool isBuiltInKey(String fontKey) =>
      builtInItems.values.contains(fontKey);

  static bool isCustomKey(String fontKey) => fontKey.startsWith('custom-');
}
