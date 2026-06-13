import 'dart:typed_data';

class CustomFont {
  const CustomFont({
    required this.id,
    required this.displayName,
    required this.fontKey,
    required this.bytes,
  });

  final String id;
  final String displayName;
  final String fontKey;
  final Uint8List bytes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'fontKey': fontKey,
        'bytes': bytes,
      };

  factory CustomFont.fromJson(Map<dynamic, dynamic> json) {
    final rawBytes = json['bytes'];
    return CustomFont(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      fontKey: json['fontKey'] as String,
      bytes: rawBytes is Uint8List
          ? rawBytes
          : Uint8List.fromList(List<int>.from(rawBytes as List)),
    );
  }
}
