// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_size_preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoverSizePreset _$CoverSizePresetFromJson(Map<String, dynamic> json) =>
    _CoverSizePreset(
      label: json['label'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$CoverSizePresetToJson(_CoverSizePreset instance) =>
    <String, dynamic>{
      'label': instance.label,
      'width': instance.width,
      'height': instance.height,
    };
