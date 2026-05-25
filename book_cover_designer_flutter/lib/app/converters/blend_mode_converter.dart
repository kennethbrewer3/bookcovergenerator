import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

class BlendModeConverter
    implements JsonConverter<BlendMode, String> {
  const BlendModeConverter();

  @override
  BlendMode fromJson(String json) {
    return BlendMode.values.firstWhere(
          (e) => e.name == json,
    );
  }

  @override
  String toJson(BlendMode object) => object.name;
}