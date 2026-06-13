// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebook_cover_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EbookCoverSettings _$EbookCoverSettingsFromJson(
  Map<String, dynamic> json,
) => _EbookCoverSettings(
  coverWidth: (json['coverWidth'] as num?)?.toDouble() ?? 1600,
  coverHeight: (json['coverHeight'] as num?)?.toDouble() ?? 2560,
  title: json['title'] as String? ?? 'Book Title',
  author: json['author'] as String? ?? 'Author Name',
  subtitle: json['subtitle'] as String?,
  tagline: json['tagline'] as String?,
  seriesTitle: json['seriesTitle'] as String?,
  editionLine: json['editionLine'] as String?,
  cornerBadgeText: json['cornerBadgeText'] as String?,
  titleQuillDelta: (json['titleQuillDelta'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  authorQuillDelta: (json['authorQuillDelta'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  subtitleQuillDelta: (json['subtitleQuillDelta'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  taglineQuillDelta: (json['taglineQuillDelta'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  seriesTitleQuillDelta: (json['seriesTitleQuillDelta'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  editionLineQuillDelta: (json['editionLineQuillDelta'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  cornerBadgeQuillDelta: (json['cornerBadgeQuillDelta'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  backgroundColor: json['backgroundColor'] == null
      ? const Color(0xFF1E1E1E)
      : const ColorJsonConverter().fromJson(
          (json['backgroundColor'] as num).toInt(),
        ),
  titleTextColor: json['titleTextColor'] == null
      ? Colors.white
      : const ColorJsonConverter().fromJson(
          (json['titleTextColor'] as num).toInt(),
        ),
  authorTextColor: json['authorTextColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['authorTextColor'] as num).toInt(),
        ),
  subtitleTextColor: json['subtitleTextColor'] == null
      ? Colors.black
      : const ColorJsonConverter().fromJson(
          (json['subtitleTextColor'] as num).toInt(),
        ),
  titleBoxColor: json['titleBoxColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['titleBoxColor'] as num).toInt(),
        ),
  titleBorderColor: json['titleBorderColor'] == null
      ? Colors.white
      : const ColorJsonConverter().fromJson(
          (json['titleBorderColor'] as num).toInt(),
        ),
  authorBoxColor: json['authorBoxColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['authorBoxColor'] as num).toInt(),
        ),
  authorBorderColor: json['authorBorderColor'] == null
      ? Colors.white
      : const ColorJsonConverter().fromJson(
          (json['authorBorderColor'] as num).toInt(),
        ),
  subtitleBoxColor: json['subtitleBoxColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['subtitleBoxColor'] as num).toInt(),
        ),
  subtitleBorderColor: json['subtitleBorderColor'] == null
      ? Colors.white
      : const ColorJsonConverter().fromJson(
          (json['subtitleBorderColor'] as num).toInt(),
        ),
  taglineTextColor: json['taglineTextColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['taglineTextColor'] as num).toInt(),
        ),
  taglineBoxColor: json['taglineBoxColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['taglineBoxColor'] as num).toInt(),
        ),
  taglineBorderColor: json['taglineBorderColor'] == null
      ? Colors.white
      : const ColorJsonConverter().fromJson(
          (json['taglineBorderColor'] as num).toInt(),
        ),
  seriesTitleTextColor: json['seriesTitleTextColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['seriesTitleTextColor'] as num).toInt(),
        ),
  seriesTitleBoxColor: json['seriesTitleBoxColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['seriesTitleBoxColor'] as num).toInt(),
        ),
  seriesTitleBorderColor: json['seriesTitleBorderColor'] == null
      ? Colors.white
      : const ColorJsonConverter().fromJson(
          (json['seriesTitleBorderColor'] as num).toInt(),
        ),
  editionLineTextColor: json['editionLineTextColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['editionLineTextColor'] as num).toInt(),
        ),
  editionLineBoxColor: json['editionLineBoxColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['editionLineBoxColor'] as num).toInt(),
        ),
  editionLineBorderColor: json['editionLineBorderColor'] == null
      ? Colors.white
      : const ColorJsonConverter().fromJson(
          (json['editionLineBorderColor'] as num).toInt(),
        ),
  cornerBadgeTextColor: json['cornerBadgeTextColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['cornerBadgeTextColor'] as num).toInt(),
        ),
  cornerBadgeColor: json['cornerBadgeColor'] == null
      ? Colors.white70
      : const ColorJsonConverter().fromJson(
          (json['cornerBadgeColor'] as num).toInt(),
        ),
  cornerBadgeBorderColor: json['cornerBadgeBorderColor'] == null
      ? Colors.white
      : const ColorJsonConverter().fromJson(
          (json['cornerBadgeBorderColor'] as num).toInt(),
        ),
  layout:
      $enumDecodeNullable(_$CoverLayoutEnumMap, json['layout']) ??
      CoverLayout.bigCenterTitle,
  taglineTopOffset: (json['taglineTopOffset'] as num?)?.toDouble() ?? 0,
  seriesTitleTopOffset: (json['seriesTitleTopOffset'] as num?)?.toDouble() ?? 0,
  editionLineTopOffset: (json['editionLineTopOffset'] as num?)?.toDouble() ?? 0,
  titleTopOffset: (json['titleTopOffset'] as num?)?.toDouble() ?? 0,
  authorTopOffset: (json['authorTopOffset'] as num?)?.toDouble() ?? 0,
  subtitleTopOffset: (json['subtitleTopOffset'] as num?)?.toDouble() ?? 0,
  titleTopAuthorBottomTopOffset:
      (json['titleTopAuthorBottomTopOffset'] as num?)?.toDouble() ?? 0,
  authorTopTitleCenterTopOffset:
      (json['authorTopTitleCenterTopOffset'] as num?)?.toDouble() ?? 0,
  titleHorizontalOffset:
      (json['titleHorizontalOffset'] as num?)?.toDouble() ?? 0,
  authorHorizontalOffset:
      (json['authorHorizontalOffset'] as num?)?.toDouble() ?? 0,
  subtitleHorizontalOffset:
      (json['subtitleHorizontalOffset'] as num?)?.toDouble() ?? 0,
  taglineHorizontalOffset:
      (json['taglineHorizontalOffset'] as num?)?.toDouble() ?? 0,
  seriesTitleHorizontalOffset:
      (json['seriesTitleHorizontalOffset'] as num?)?.toDouble() ?? 0,
  editionLineHorizontalOffset:
      (json['editionLineHorizontalOffset'] as num?)?.toDouble() ?? 0,
  titleTextAlign:
      $enumDecodeNullable(_$TextAlignEnumMap, json['titleTextAlign']) ??
      TextAlign.center,
  authorTextAlign:
      $enumDecodeNullable(_$TextAlignEnumMap, json['authorTextAlign']) ??
      TextAlign.center,
  subtitleTextAlign:
      $enumDecodeNullable(_$TextAlignEnumMap, json['subtitleTextAlign']) ??
      TextAlign.center,
  taglineTextAlign:
      $enumDecodeNullable(_$TextAlignEnumMap, json['taglineTextAlign']) ??
      TextAlign.center,
  seriesTitleTextAlign:
      $enumDecodeNullable(_$TextAlignEnumMap, json['seriesTitleTextAlign']) ??
      TextAlign.center,
  editionLineTextAlign:
      $enumDecodeNullable(_$TextAlignEnumMap, json['editionLineTextAlign']) ??
      TextAlign.center,
  cornerBadgeTextAlign:
      $enumDecodeNullable(_$TextAlignEnumMap, json['cornerBadgeTextAlign']) ??
      TextAlign.center,
  cornerBadgePosition:
      $enumDecodeNullable(
        _$CornerBadgePositionEnumMap,
        json['cornerBadgePosition'],
      ) ??
      CornerBadgePosition.topRight,
  backgroundImageBytes: const Uint8ListBase64Converter().fromJson(
    json['backgroundImageBytes'] as String?,
  ),
  backgroundImageMode:
      $enumDecodeNullable(
        _$BackgroundImageModeEnumMap,
        json['backgroundImageMode'],
      ) ??
      BackgroundImageMode.cover,
  backgroundImageAlignment: json['backgroundImageAlignment'] == null
      ? Alignment.center
      : const AlignmentConverter().fromJson(
          json['backgroundImageAlignment'] as Map<String, dynamic>,
        ),
  backgroundImageScaleX:
      (json['backgroundImageScaleX'] as num?)?.toDouble() ?? 1,
  backgroundImageScaleY:
      (json['backgroundImageScaleY'] as num?)?.toDouble() ?? 1,
  backgroundBlendMode: json['backgroundBlendMode'] == null
      ? BlendMode.srcOver
      : const BlendModeConverter().fromJson(
          json['backgroundBlendMode'] as String,
        ),
  backgroundImageOpacity:
      (json['backgroundImageOpacity'] as num?)?.toDouble() ?? 1,
);

Map<String, dynamic> _$EbookCoverSettingsToJson(
  _EbookCoverSettings instance,
) => <String, dynamic>{
  'coverWidth': instance.coverWidth,
  'coverHeight': instance.coverHeight,
  'title': instance.title,
  'author': instance.author,
  'subtitle': instance.subtitle,
  'tagline': instance.tagline,
  'seriesTitle': instance.seriesTitle,
  'editionLine': instance.editionLine,
  'cornerBadgeText': instance.cornerBadgeText,
  'titleQuillDelta': instance.titleQuillDelta,
  'authorQuillDelta': instance.authorQuillDelta,
  'subtitleQuillDelta': instance.subtitleQuillDelta,
  'taglineQuillDelta': instance.taglineQuillDelta,
  'seriesTitleQuillDelta': instance.seriesTitleQuillDelta,
  'editionLineQuillDelta': instance.editionLineQuillDelta,
  'cornerBadgeQuillDelta': instance.cornerBadgeQuillDelta,
  'backgroundColor': const ColorJsonConverter().toJson(
    instance.backgroundColor,
  ),
  'titleTextColor': const ColorJsonConverter().toJson(instance.titleTextColor),
  'authorTextColor': const ColorJsonConverter().toJson(
    instance.authorTextColor,
  ),
  'subtitleTextColor': const ColorJsonConverter().toJson(
    instance.subtitleTextColor,
  ),
  'titleBoxColor': const ColorJsonConverter().toJson(instance.titleBoxColor),
  'titleBorderColor': const ColorJsonConverter().toJson(
    instance.titleBorderColor,
  ),
  'authorBoxColor': const ColorJsonConverter().toJson(instance.authorBoxColor),
  'authorBorderColor': const ColorJsonConverter().toJson(
    instance.authorBorderColor,
  ),
  'subtitleBoxColor': const ColorJsonConverter().toJson(
    instance.subtitleBoxColor,
  ),
  'subtitleBorderColor': const ColorJsonConverter().toJson(
    instance.subtitleBorderColor,
  ),
  'taglineTextColor': const ColorJsonConverter().toJson(
    instance.taglineTextColor,
  ),
  'taglineBoxColor': const ColorJsonConverter().toJson(
    instance.taglineBoxColor,
  ),
  'taglineBorderColor': const ColorJsonConverter().toJson(
    instance.taglineBorderColor,
  ),
  'seriesTitleTextColor': const ColorJsonConverter().toJson(
    instance.seriesTitleTextColor,
  ),
  'seriesTitleBoxColor': const ColorJsonConverter().toJson(
    instance.seriesTitleBoxColor,
  ),
  'seriesTitleBorderColor': const ColorJsonConverter().toJson(
    instance.seriesTitleBorderColor,
  ),
  'editionLineTextColor': const ColorJsonConverter().toJson(
    instance.editionLineTextColor,
  ),
  'editionLineBoxColor': const ColorJsonConverter().toJson(
    instance.editionLineBoxColor,
  ),
  'editionLineBorderColor': const ColorJsonConverter().toJson(
    instance.editionLineBorderColor,
  ),
  'cornerBadgeTextColor': const ColorJsonConverter().toJson(
    instance.cornerBadgeTextColor,
  ),
  'cornerBadgeColor': const ColorJsonConverter().toJson(
    instance.cornerBadgeColor,
  ),
  'cornerBadgeBorderColor': const ColorJsonConverter().toJson(
    instance.cornerBadgeBorderColor,
  ),
  'layout': _$CoverLayoutEnumMap[instance.layout]!,
  'taglineTopOffset': instance.taglineTopOffset,
  'seriesTitleTopOffset': instance.seriesTitleTopOffset,
  'editionLineTopOffset': instance.editionLineTopOffset,
  'titleTopOffset': instance.titleTopOffset,
  'authorTopOffset': instance.authorTopOffset,
  'subtitleTopOffset': instance.subtitleTopOffset,
  'titleTopAuthorBottomTopOffset': instance.titleTopAuthorBottomTopOffset,
  'authorTopTitleCenterTopOffset': instance.authorTopTitleCenterTopOffset,
  'titleHorizontalOffset': instance.titleHorizontalOffset,
  'authorHorizontalOffset': instance.authorHorizontalOffset,
  'subtitleHorizontalOffset': instance.subtitleHorizontalOffset,
  'taglineHorizontalOffset': instance.taglineHorizontalOffset,
  'seriesTitleHorizontalOffset': instance.seriesTitleHorizontalOffset,
  'editionLineHorizontalOffset': instance.editionLineHorizontalOffset,
  'titleTextAlign': _$TextAlignEnumMap[instance.titleTextAlign]!,
  'authorTextAlign': _$TextAlignEnumMap[instance.authorTextAlign]!,
  'subtitleTextAlign': _$TextAlignEnumMap[instance.subtitleTextAlign]!,
  'taglineTextAlign': _$TextAlignEnumMap[instance.taglineTextAlign]!,
  'seriesTitleTextAlign': _$TextAlignEnumMap[instance.seriesTitleTextAlign]!,
  'editionLineTextAlign': _$TextAlignEnumMap[instance.editionLineTextAlign]!,
  'cornerBadgeTextAlign': _$TextAlignEnumMap[instance.cornerBadgeTextAlign]!,
  'cornerBadgePosition':
      _$CornerBadgePositionEnumMap[instance.cornerBadgePosition]!,
  'backgroundImageBytes': const Uint8ListBase64Converter().toJson(
    instance.backgroundImageBytes,
  ),
  'backgroundImageMode':
      _$BackgroundImageModeEnumMap[instance.backgroundImageMode]!,
  'backgroundImageAlignment': const AlignmentConverter().toJson(
    instance.backgroundImageAlignment,
  ),
  'backgroundImageScaleX': instance.backgroundImageScaleX,
  'backgroundImageScaleY': instance.backgroundImageScaleY,
  'backgroundBlendMode': const BlendModeConverter().toJson(
    instance.backgroundBlendMode,
  ),
  'backgroundImageOpacity': instance.backgroundImageOpacity,
};

const _$CoverLayoutEnumMap = {
  CoverLayout.titleTopAuthorBottom: 'titleTopAuthorBottom',
  CoverLayout.authorTopTitleCenter: 'authorTopTitleCenter',
  CoverLayout.bigCenterTitle: 'bigCenterTitle',
};

const _$TextAlignEnumMap = {
  TextAlign.left: 'left',
  TextAlign.right: 'right',
  TextAlign.center: 'center',
  TextAlign.justify: 'justify',
  TextAlign.start: 'start',
  TextAlign.end: 'end',
};

const _$CornerBadgePositionEnumMap = {
  CornerBadgePosition.topLeft: 'topLeft',
  CornerBadgePosition.topRight: 'topRight',
  CornerBadgePosition.bottomLeft: 'bottomLeft',
  CornerBadgePosition.bottomRight: 'bottomRight',
};

const _$BackgroundImageModeEnumMap = {
  BackgroundImageMode.cover: 'cover',
  BackgroundImageMode.contain: 'contain',
  BackgroundImageMode.stretch: 'stretch',
  BackgroundImageMode.center: 'center',
  BackgroundImageMode.tile: 'tile',
  BackgroundImageMode.tileX: 'tileX',
  BackgroundImageMode.tileY: 'tileY',
};
