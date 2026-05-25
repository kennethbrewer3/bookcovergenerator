import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class AlignmentConverter
    implements JsonConverter<Alignment, Map<String, dynamic>> {
  const AlignmentConverter();

  @override
  Alignment fromJson(Map<String, dynamic> json) {
    return Alignment(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Alignment object) {
    return {
      'x': object.x,
      'y': object.y,
    };
  }
}