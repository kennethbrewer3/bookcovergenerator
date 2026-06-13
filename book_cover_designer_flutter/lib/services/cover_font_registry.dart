import 'package:flutter/services.dart';

/// Registers bundled cover fonts under the Quill font keys so the editor and
/// toolbar can preview them via [TextStyle.fontFamily].
class CoverFontRegistry {
  CoverFontRegistry._();

  static final Set<String> _loadedKeys = {};

  static const builtInAssetMap = <String, String>{
    'sans-serif': 'assets/google_fonts/Roboto-Regular.ttf',
    'serif': 'assets/google_fonts/Merriweather-Regular.ttf',
    'monospace': 'assets/google_fonts/RobotoMono-Regular.ttf',
    'ibarra-real-nova': 'assets/google_fonts/IbarraRealNova-Regular.ttf',
    'square-peg': 'assets/google_fonts/SquarePeg-Regular.ttf',
    'nunito': 'assets/google_fonts/Nunito-Regular.ttf',
    'pacifico': 'assets/google_fonts/Pacifico-Regular.ttf',
    'roboto-mono': 'assets/google_fonts/RobotoMono-Regular.ttf',
  };

  static Future<void> registerBuiltInFonts() async {
    for (final entry in builtInAssetMap.entries) {
      await registerFontKey(entry.key, assetPath: entry.value);
    }
  }

  static Future<void> registerFontKey(
    String fontKey, {
    required String assetPath,
  }) async {
    if (_loadedKeys.contains(fontKey)) return;

    final data = await rootBundle.load(assetPath);
    final loader = FontLoader(fontKey);
    loader.addFont(Future<ByteData>.value(data));
    await loader.load();
    _loadedKeys.add(fontKey);
  }

  static bool isRegistered(String fontKey) => _loadedKeys.contains(fontKey);
}
