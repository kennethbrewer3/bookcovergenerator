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
    List<Map<String, dynamic>>? titleQuillDelta,
    List<Map<String, dynamic>>? authorQuillDelta,
    List<Map<String, dynamic>>? subtitleQuillDelta,
    List<Map<String, dynamic>>? taglineQuillDelta,
    List<Map<String, dynamic>>? seriesTitleQuillDelta,
    List<Map<String, dynamic>>? editionLineQuillDelta,
    List<Map<String, dynamic>>? cornerBadgeQuillDelta,

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
    @Default(Colors.white)
    Color titleBorderColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color authorBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white)
    Color authorBorderColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color subtitleBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white)
    Color subtitleBorderColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color taglineTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color taglineBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white)
    Color taglineBorderColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color seriesTitleTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color seriesTitleBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white)
    Color seriesTitleBorderColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color editionLineTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color editionLineBoxColor,

    @ColorJsonConverter()
    @Default(Colors.white)
    Color editionLineBorderColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color cornerBadgeTextColor,

    @ColorJsonConverter()
    @Default(Colors.white70)
    Color cornerBadgeColor,

    @ColorJsonConverter()
    @Default(Colors.white)
    Color cornerBadgeBorderColor,

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

    @Default(TextAlign.center) TextAlign titleTextAlign,
    @Default(TextAlign.center) TextAlign authorTextAlign,
    @Default(TextAlign.center) TextAlign subtitleTextAlign,
    @Default(TextAlign.center) TextAlign taglineTextAlign,
    @Default(TextAlign.center) TextAlign seriesTitleTextAlign,
    @Default(TextAlign.center) TextAlign editionLineTextAlign,
    @Default(TextAlign.center) TextAlign cornerBadgeTextAlign,

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