import 'package:freezed_annotation/freezed_annotation.dart';

part 'cover_size_preset.freezed.dart';
part 'cover_size_preset.g.dart';

@freezed
abstract class CoverSizePreset with _$CoverSizePreset {
  const factory CoverSizePreset({
    required String label,
    required double width,
    required double height,
  }) = _CoverSizePreset;

  factory CoverSizePreset.fromJson(Map<String, dynamic> json) => _$CoverSizePresetFromJson(json);

  const CoverSizePreset._();
}