import 'package:book_cover_designer_flutter/models/custom_font.dart';
import 'package:book_cover_designer_flutter/services/cover_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomFontService {
  static const _boxName = 'custom_fonts_v1';

  final ValueNotifier<List<CustomFont>> fonts = ValueNotifier(const []);
  final Set<String> _loadedFontKeys = {};

  Box<Map>? _box;

  CustomFontService._();

  static Future<CustomFontService> create() async {
    final service = CustomFontService._();
    await service._loadStoredFonts();
    return service;
  }

  Future<void> _loadStoredFonts() async {
    _box = await Hive.openBox<Map>(_boxName);
    final loaded = <CustomFont>[];
    for (final key in _box!.keys) {
      final raw = _box!.get(key);
      if (raw is! Map) continue;
      try {
        final font = CustomFont.fromJson(Map<dynamic, dynamic>.from(raw));
        loaded.add(font);
        await _registerFont(font);
      } catch (e) {
        debugPrint('[CustomFontService] skipped corrupt entry "$key": $e');
      }
    }
    loaded.sort((a, b) => a.displayName.compareTo(b.displayName));
    fonts.value = loaded;
  }

  Future<void> preloadAll() async {
    for (final font in fonts.value) {
      await _registerFont(font);
    }
  }

  Future<String?> importFonts() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['ttf', 'otf'],
      allowMultiple: true,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final errors = <String>[];
    final imported = <CustomFont>[];

    for (final file in result.files) {
      final bytes = file.bytes;
      if (bytes == null || bytes.isEmpty) {
        errors.add(file.name);
        continue;
      }
      if (!_isSupportedFontBytes(bytes)) {
        errors.add(file.name);
        continue;
      }

      final displayName = _displayNameFromFileName(file.name);
      final id = '${DateTime.now().microsecondsSinceEpoch}_${displayName.hashCode}';
      final font = CustomFont(
        id: id,
        displayName: displayName,
        fontKey: 'custom-$id',
        bytes: Uint8List.fromList(bytes),
      );

      await _persistFont(font);
      await _registerFont(font);
      imported.add(font);
    }

    if (imported.isEmpty) {
      return errors.isEmpty ? null : errors.join(', ');
    }

    final merged = [...fonts.value, ...imported]
      ..sort((a, b) => a.displayName.compareTo(b.displayName));
    fonts.value = merged;

    if (errors.isNotEmpty) {
      return errors.join(', ');
    }
    return null;
  }

  Future<void> removeFont(CustomFont font) async {
    await _box?.delete(font.id);
    _loadedFontKeys.remove(font.fontKey);
    fonts.value = fonts.value.where((f) => f.id != font.id).toList();
  }

  CustomFont? findByKey(String fontKey) {
    for (final font in fonts.value) {
      if (font.fontKey == fontKey) return font;
    }
    return null;
  }

  bool isCustomFontKey(String fontKey) => CoverFonts.isCustomKey(fontKey);

  Future<void> _persistFont(CustomFont font) async {
    await _box?.put(font.id, font.toJson());
  }

  Future<void> _registerFont(CustomFont font) async {
    if (_loadedFontKeys.contains(font.fontKey)) return;

    final loader = FontLoader(font.fontKey);
    loader.addFont(Future<ByteData>.value(font.bytes.buffer.asByteData()));
    await loader.load();
    _loadedFontKeys.add(font.fontKey);
  }

  static bool _isSupportedFontBytes(List<int> bytes) {
    if (bytes.length < 4) return false;

    // TrueType / OpenType with CFF
    if (bytes[0] == 0x00 &&
        bytes[1] == 0x01 &&
        bytes[2] == 0x00 &&
        bytes[3] == 0x00) {
      return true;
    }

    // OpenType
    if (bytes[0] == 0x4F &&
        bytes[1] == 0x54 &&
        bytes[2] == 0x54 &&
        bytes[3] == 0x4F) {
      return true;
    }

    // TrueType
    if (bytes[0] == 0x74 &&
        bytes[1] == 0x72 &&
        bytes[2] == 0x75 &&
        bytes[3] == 0x65) {
      return true;
    }

    // TrueType (Mac)
    if (bytes[0] == 0x00 &&
        bytes[1] == 0x01 &&
        bytes[2] == 0x00 &&
        bytes[3] == 0x01) {
      return true;
    }

    return false;
  }

  static String _displayNameFromFileName(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    final base = dotIndex <= 0 ? fileName : fileName.substring(0, dotIndex);
    return base.replaceAll(RegExp(r'[_-]+'), ' ').trim();
  }
}
