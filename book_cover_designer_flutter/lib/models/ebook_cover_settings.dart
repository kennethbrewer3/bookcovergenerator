import 'dart:typed_data';

import 'package:book_cover_designer_flutter/app/converters/alignment_converter.dart';
import 'package:book_cover_designer_flutter/app/converters/blend_mode_converter.dart';
import 'package:book_cover_designer_flutter/app/converters/color_json_converter.dart';
import 'package:book_cover_designer_flutter/app/converters/uint8_list_base64_converter.dart';
import 'package:book_cover_designer_flutter/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ebook_cover_settings.freezed.dart';
part 'ebook_cover_settings.g.dart';

@freezed
abstract class EbookCoverSettings with _$EbookCoverSettings {
  const factory EbookCoverSettings({
    @Default(1600) double coverWidth,
    @Default(2560) double coverHeight,

    @Default('Book Title') String title,
    @Default('Author Name') String author,

    String? subtitle,
    String? tagline,
    String? seriesTitle,
    String? editionLine,
    String? cornerBadgeText,

    @ColorJsonConverter()
    @Default(Color(0xFF1E1E1E))
    Color backgroundColor,

    @ColorJsonConverter()
    @Default(Colors.white)
    Color titleTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color authorTextColor,

    @ColorJsonConverter()
    @Default(Colors.black)
    Color subtitleTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color titleBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color authorBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color subtitleBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color taglineTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color taglineBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color seriesTitleTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color seriesTitleBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color editionLineTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color editionLineBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color cornerBadgeTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color cornerBadgeColor,

    @Default(CoverLayout.bigCenterTitle)
    CoverLayout layout,

    @Default(0) double taglineTopOffset,
    @Default(0) double seriesTitleTopOffset,
    @Default(0) double editionLineTopOffset,
    @Default(0) double titleTopOffset,
    @Default(0) double authorTopOffset,
    @Default(0) double subtitleTopOffset,
    @Default(0) double titleTopAuthorBottomTopOffset,
    @Default(0) double authorTopTitleCenterTopOffset,

    @Default(0) double titleHorizontalOffset,
    @Default(0) double authorHorizontalOffset,
    @Default(0) double subtitleHorizontalOffset,
    @Default(0) double taglineHorizontalOffset,
    @Default(0) double seriesTitleHorizontalOffset,
    @Default(0) double editionLineHorizontalOffset,

    @Default(CornerBadgePosition.topRight)
    CornerBadgePosition cornerBadgePosition,

    @Uint8ListBase64Converter()
    Uint8List? backgroundImageBytes,

    @Default(BackgroundImageMode.cover)
    BackgroundImageMode backgroundImageMode,

    @AlignmentConverter()
    @Default(Alignment.center)
    Alignment backgroundImageAlignment,

    @Default(1) double backgroundImageScaleX,
    @Default(1) double backgroundImageScaleY,

    @BlendModeConverter()
    @Default(BlendMode.srcOver)
    BlendMode backgroundBlendMode,

    @Default(1) double backgroundImageOpacity,

  }) = _EbookCoverSettings;

  factory EbookCoverSettings.fromJson(Map<String, dynamic> json) =>
      _$EbookCoverSettingsFromJson(json);

  const EbookCoverSettings._();

  factory EbookCoverSettings.defaults() =>
      const EbookCoverSettings();
}