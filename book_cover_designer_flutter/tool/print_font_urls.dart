// Run with: dart run tool/print_font_urls.dart
//
// Lists the bundled cover font files. To (re)download them, run:
//   dart run tool/download_cover_fonts.dart
import 'dart:io';

void main() {
  final dir = Directory('assets/google_fonts');
  if (!dir.existsSync()) {
    stderr.writeln('No bundled fonts found. Run tool/download_cover_fonts.dart first.');
    exit(1);
  }

  final files = dir
      .listSync()
      .whereType<File>()
      .map((f) => f.uri.pathSegments.last)
      .where((name) => name.endsWith('.ttf'))
      .toList()
    ..sort();

  for (final name in files) {
    stdout.writeln(name);
  }
  stdout.writeln('${files.length} font files');
}
