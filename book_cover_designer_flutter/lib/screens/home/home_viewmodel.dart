import 'dart:async';
import 'dart:typed_data';

import 'package:book_cover_designer_flutter/app/app.locator.dart';
import 'package:book_cover_designer_flutter/models/cover_size_preset.dart';
import 'package:book_cover_designer_flutter/models/ebook_cover_settings.dart';
import 'package:book_cover_designer_flutter/models/enums.dart';
import 'package:book_cover_designer_flutter/services/generate_ebook_cover_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

enum HomeFormSection {
  background,
  ebookDetails,
  layout,
  actions,
}

class HomeViewModel extends BaseViewModel {

  static const fallbackCoverSizePresets = [
    CoverSizePreset(
      label: 'Amazon KDP Max — 6250 x 10000',
      width: 6250,
      height: 10000,
    ),
    CoverSizePreset(
      label: 'Amazon KDP Recommended — 1600 x 2560',
      width: 1600,
      height: 2560,
    ),
    CoverSizePreset(
      label: 'Amazon KDP Minimum — 625 x 1000',
      width: 625,
      height: 1000,
    ),
    CoverSizePreset(label: '3:4 — 1800 x 2400', width: 1800, height: 2400),
    CoverSizePreset(label: '3:4 — 1500 x 2000', width: 1500, height: 2000),
    CoverSizePreset(label: '3:4 — 900 x 1200', width: 900, height: 1200),
    CoverSizePreset(label: '3:4 — 768 x 1024', width: 768, height: 1024),
    CoverSizePreset(label: '3:4 — 600 x 800', width: 600, height: 800),
  ];

  // ---- validation rules ----
  static const int minTitleLength = 3;
  static const int minAuthorLength = 2;

  final _coverService = locator<GenerateEbookCoverService>();

  final ebookTitleController = TextEditingController();
  final authorNameController = TextEditingController();
  final subtitleController = TextEditingController();
  final taglineController = TextEditingController();
  final seriesTitleController = TextEditingController();
  final editionLineController = TextEditingController();
  final cornerBadgeTextController = TextEditingController();
  final authorFocusNode = FocusNode();
  final seriesTitleFocusNode = FocusNode();

  ByteData? _cover;
  ByteData? get cover => _cover;
  final List<CoverSizePreset> _coverSizePresets = fallbackCoverSizePresets;
  List<CoverSizePreset> get coverSizePresets => _coverSizePresets;
  CoverSizePreset _selectedCoverSizePreset = fallbackCoverSizePresets.last;
  CoverSizePreset get selectedCoverSizePreset => _selectedCoverSizePreset;
  double get coverWidth => _selectedCoverSizePreset.width;
  double get coverHeight => _selectedCoverSizePreset.height;

  CoverLayout _selectedLayout = CoverLayout.bigCenterTitle;
  CoverLayout get selectedLayout => _selectedLayout;
  CornerBadgePosition _selectedCornerBadgePosition =
      CornerBadgePosition.topRight;
  CornerBadgePosition get selectedCornerBadgePosition =>
      _selectedCornerBadgePosition;

  // Optional: keep these if you use them elsewhere
  String ebookTitle = '';
  String authorName = '';
  Timer? _coverUpdateDebounce;
  bool _hasPendingCoverUpdate = false;
  double _taglineTopOffset = 0;
  double get taglineTopOffset => _taglineTopOffset;
  double _seriesTitleTopOffset = 0;
  double get seriesTitleTopOffset => _seriesTitleTopOffset;
  double _editionLineTopOffset = 0;
  double get editionLineTopOffset => _editionLineTopOffset;
  double _titleTopOffset = 0;
  double get titleTopOffset => _titleTopOffset;
  double _authorTopOffset = 0;
  double get authorTopOffset => _authorTopOffset;
  double _subtitleTopOffset = 0;
  double get subtitleTopOffset => _subtitleTopOffset;
  double _titleTopAuthorBottomTopOffset = 0;
  double get titleTopAuthorBottomTopOffset => _titleTopAuthorBottomTopOffset;
  double _authorTopTitleCenterTopOffset = 0;
  double get authorTopTitleCenterTopOffset => _authorTopTitleCenterTopOffset;
  Color backgroundColor = const Color(0xFF1E293B);
  Color titleTextColor = Colors.white;
  Color subtitleTextColor = Colors.white70;
  Color authorTextColor = Colors.white;
  Color titleBoxColor = const Color(0x66000000);
  Color authorBoxColor = const Color(0x66000000);
  Color subtitleBoxColor = const Color(0x66000000);
  Color taglineTextColor = Colors.white;
  Color taglineBoxColor = const Color(0x66000000);
  Color seriesTitleTextColor = Colors.white;
  Color seriesTitleBoxColor = const Color(0x66000000);
  Color editionLineTextColor = Colors.white;
  Color editionLineBoxColor = const Color(0x66000000);
  Color cornerBadgeTextColor = Colors.white;
  Color cornerBadgeColor = const Color(0xAA000000);
  bool _hasSelectedBackgroundColor = false;
  Uint8List? backgroundImageBytes;
  String? backgroundImageName;
  BackgroundImageMode backgroundImageMode = BackgroundImageMode.cover;
  Alignment backgroundImageAlignment = Alignment.center;
  double backgroundImageScaleX = 1;
  double backgroundImageScaleY = 1;
  BlendMode backgroundBlendMode = BlendMode.srcOver;
  double backgroundImageOpacity = 1;

  double _titleHorizontalOffset = 0;
  double get titleHorizontalOffset => _titleHorizontalOffset;

  double _authorHorizontalOffset = 0;
  double get authorHorizontalOffset => _authorHorizontalOffset;

  double _subtitleHorizontalOffset = 0;
  double get subtitleHorizontalOffset => _subtitleHorizontalOffset;

  double _taglineHorizontalOffset = 0;
  double get taglineHorizontalOffset => _taglineHorizontalOffset;

  double _seriesTitleHorizontalOffset = 0;
  double get seriesTitleHorizontalOffset => _seriesTitleHorizontalOffset;

  double _editionLineHorizontalOffset = 0;
  double get editionLineHorizontalOffset => _editionLineHorizontalOffset;

  final Set<HomeFormSection> _expandedFormSections = {
    HomeFormSection.background,
    HomeFormSection.ebookDetails,
    HomeFormSection.layout,
    HomeFormSection.actions,
  };

  HomeViewModel() {
    // Keep VM state in sync with controllers and recompute validity on every edit
    ebookTitleController.addListener(_onFieldsChanged);
    authorNameController.addListener(_onFieldsChanged);
    subtitleController.addListener(_onFieldsChanged);
    taglineController.addListener(_onFieldsChanged);
    seriesTitleController.addListener(_onFieldsChanged);
    editionLineController.addListener(_onFieldsChanged);
    cornerBadgeTextController.addListener(_onFieldsChanged);
  }

  // SegmentedButton expects a Set
  Set<CoverLayout> get selectedLayoutSet => {_selectedLayout};
  Set<CornerBadgePosition> get selectedCornerBadgePositionSet => {
    _selectedCornerBadgePosition,
  };

  bool isFormSectionExpanded(HomeFormSection section) =>
      _expandedFormSections.contains(section);

  void setFormSectionExpanded(HomeFormSection section, bool isExpanded) {
    if (isExpanded) {
      _expandedFormSections.add(section);
    } else {
      _expandedFormSections.remove(section);
    }
    notifyListeners();
  }

  void setCoverSizePreset(CoverSizePreset value) {
    if (_selectedCoverSizePreset == value) return;
    _selectedCoverSizePreset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setTitleHorizontalOffset(double value) {
    if (_titleHorizontalOffset == value) return;
    _titleHorizontalOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setAuthorHorizontalOffset(double value) {
    if (_authorHorizontalOffset == value) return;
    _authorHorizontalOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setSubtitleHorizontalOffset(double value) {
    if (_subtitleHorizontalOffset == value) return;
    _subtitleHorizontalOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setTaglineHorizontalOffset(double value) {
    if (_taglineHorizontalOffset == value) return;
    _taglineHorizontalOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setSeriesTitleHorizontalOffset(double value) {
    if (_seriesTitleHorizontalOffset == value) return;
    _seriesTitleHorizontalOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setEditionLineHorizontalOffset(double value) {
    if (_editionLineHorizontalOffset == value) return;
    _editionLineHorizontalOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setSelectedLayout(CoverLayout value) {
    if (_selectedLayout == value) return;
    _selectedLayout = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setSelectedCornerBadgePosition(CornerBadgePosition value) {
    if (_selectedCornerBadgePosition == value) return;
    _selectedCornerBadgePosition = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  Future<void> pickBackgroundImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final file = result?.files.single;
    if (file == null || file.bytes == null) return;
    backgroundImageBytes = file.bytes;
    backgroundImageName = file.name;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void clearBackgroundImage() {
    // Clear current image bytes and name
    backgroundImageBytes = null;
    backgroundImageName = null;

    // Reset all background image properties to default
    backgroundImageMode = BackgroundImageMode.cover;
    backgroundImageAlignment = Alignment.center;
    backgroundImageScaleX = 1;
    backgroundImageScaleY = 1;
    backgroundBlendMode = BlendMode.srcOver;
    backgroundImageOpacity = 1;

    // Notify listeners and schedule cover update
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setBackgroundImageMode(BackgroundImageMode value) {
    if (backgroundImageMode == value) return;
    backgroundImageMode = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setBackgroundImageAlignment(Alignment value) {
    if (backgroundImageAlignment == value) return;
    backgroundImageAlignment = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setBackgroundImageScaleX(double value) {
    if (backgroundImageScaleX == value) return;
    backgroundImageScaleX = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setBackgroundImageScaleY(double value) {
    if (backgroundImageScaleY == value) return;
    backgroundImageScaleY = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setBackgroundBlendMode(BlendMode value) {
    if (backgroundBlendMode == value) return;
    backgroundBlendMode = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setBackgroundImageOpacity(double value) {
    if (backgroundImageOpacity == value) return;
    backgroundImageOpacity = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setTaglineTopOffset(double value) {
    if (_taglineTopOffset == value) return;
    _taglineTopOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setSeriesTitleTopOffset(double value) {
    if (_seriesTitleTopOffset == value) return;
    _seriesTitleTopOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setEditionLineTopOffset(double value) {
    if (_editionLineTopOffset == value) return;
    _editionLineTopOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setTitleTopOffset(double value) {
    if (_titleTopOffset == value) return;
    _titleTopOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setAuthorTopOffset(double value) {
    if (_authorTopOffset == value) return;
    _authorTopOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setSubtitleTopOffset(double value) {
    if (_subtitleTopOffset == value) return;
    _subtitleTopOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setTitleTopAuthorBottomTopOffset(double value) {
    if (_titleTopAuthorBottomTopOffset == value) return;
    _titleTopAuthorBottomTopOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setAuthorTopTitleCenterTopOffset(double value) {
    if (_authorTopTitleCenterTopOffset == value) return;
    _authorTopTitleCenterTopOffset = value;
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void setCoverColor(String key, Color color) {
    switch (key) {
      case 'background':
        backgroundColor = color;
        _hasSelectedBackgroundColor = true;
        break;
      case 'titleText':
        titleTextColor = color;
        break;
      case 'subtitleText':
        subtitleTextColor = color;
        break;
      case 'authorText':
        authorTextColor = color;
        break;
      case 'titleBox':
        titleBoxColor = color;
        break;
      case 'authorBox':
        authorBoxColor = color;
        break;
      case 'subtitleBox':
        subtitleBoxColor = color;
        break;
      case 'taglineText':
        taglineTextColor = color;
        break;
      case 'taglineBox':
        taglineBoxColor = color;
        break;
      case 'seriesTitleText':
        seriesTitleTextColor = color;
        break;
      case 'seriesTitleBox':
        seriesTitleBoxColor = color;
        break;
      case 'editionLineText':
        editionLineTextColor = color;
        break;
      case 'editionLineBox':
        editionLineBoxColor = color;
        break;
      case 'cornerBadgeText':
        cornerBadgeTextColor = color;
        break;
      case 'cornerBadge':
        cornerBadgeColor = color;
        break;
    }
    notifyListeners();
    _scheduleCoverUpdate();
  }

  void _onFieldsChanged() {
    ebookTitle = ebookTitleController.text;
    authorName = authorNameController.text;
    notifyListeners(); // makes isFormValid reactive
    _scheduleCoverUpdate();
  }

  // --- ViewModel validators (UI will call these in TextFormField.validator) ---
  String? validateEbookTitle(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Ebook title is required';
    if (v.length < minTitleLength) {
      return 'Ebook title must be at least $minTitleLength characters';
    }
    return null;
  }

  String? validateAuthorName(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Author name is required';
    if (v.length < minAuthorLength) {
      return 'Author name must be at least $minAuthorLength characters';
    }
    return null;
  }

  // Single source of truth for whether the form is valid (based on the validators)
  bool get isFormValid =>
      validateEbookTitle(ebookTitleController.text) == null &&
      validateAuthorName(authorNameController.text) == null;

  Future<void> fetchCover() async {
    if (isBusy) {
      _hasPendingCoverUpdate = true;
      return;
    }
    setBusy(true);
    try {
      _hasPendingCoverUpdate = false;
      final result = await _coverService.generateImage(
        settings: EbookCoverSettings(
          coverWidth: coverWidth,
          coverHeight: coverHeight,
          title: ebookTitleController.text.trim(),
          author: authorNameController.text.trim(),
          subtitle: _optionalText(subtitleController.text),
          tagline: _optionalText(taglineController.text),
          seriesTitle: _optionalText(seriesTitleController.text),
          editionLine: _optionalText(editionLineController.text),
          taglineTopOffset: taglineTopOffset,
          seriesTitleTopOffset: seriesTitleTopOffset,
          editionLineTopOffset: editionLineTopOffset,
          titleTopOffset: titleTopOffset,
          authorTopOffset: authorTopOffset,
          subtitleTopOffset: subtitleTopOffset,
          titleTopAuthorBottomTopOffset: titleTopAuthorBottomTopOffset,
          authorTopTitleCenterTopOffset: authorTopTitleCenterTopOffset,
          cornerBadgeText: _optionalText(cornerBadgeTextController.text),
          cornerBadgePosition: selectedCornerBadgePosition,
          layout: selectedLayout,
          backgroundImageBytes: backgroundImageBytes,
          backgroundImageMode: backgroundImageMode,
          backgroundImageAlignment: backgroundImageAlignment,
          backgroundImageScaleX: backgroundImageScaleX,
          backgroundImageScaleY: backgroundImageScaleY,
          backgroundBlendMode: backgroundBlendMode,
          backgroundImageOpacity: backgroundImageOpacity,
          backgroundColor: backgroundColor,
          titleTextColor: titleTextColor,
          subtitleTextColor: subtitleTextColor,
          authorTextColor: authorTextColor,
          titleBoxColor: titleBoxColor,
          authorBoxColor: authorBoxColor,
          subtitleBoxColor: subtitleBoxColor,
          taglineTextColor: taglineTextColor,
          taglineBoxColor: taglineBoxColor,
          seriesTitleTextColor: seriesTitleTextColor,
          seriesTitleBoxColor: seriesTitleBoxColor,
          editionLineTextColor: editionLineTextColor,
          editionLineBoxColor: editionLineBoxColor,
          cornerBadgeTextColor: cornerBadgeTextColor,
          cornerBadgeColor: cornerBadgeColor,
          titleHorizontalOffset: _titleHorizontalOffset,
          authorHorizontalOffset: _authorHorizontalOffset,
          subtitleHorizontalOffset: _subtitleHorizontalOffset,
          taglineHorizontalOffset: _taglineHorizontalOffset,
          seriesTitleHorizontalOffset: _seriesTitleHorizontalOffset,
          editionLineHorizontalOffset: _editionLineHorizontalOffset,
        ),
      );

      result.fold(
        (error) => setError(error),
        (data) => _cover = data,
      );
    } catch (e, st) {
      setError('Failed to generate cover: $e');
      debugPrint('fetchCover exception: $e\n$st');
    } finally {
      setBusy(false);
      if (_hasPendingCoverUpdate) {
        _scheduleCoverUpdate();
      }
    }
  }

  Future<void> saveCover() async {
    if (isBusy) return;
    if (!isFormValid) return;
    setBusy(true);
    try {
      if (_cover == null) {
        setError('Failed to save cover: null cover');
      }

      final fileNameWithoutExtension = [
        _normalizeFileNameSegment(ebookTitleController.text),
        _normalizeFileNameSegment(authorNameController.text),
        'book_cover',
      ].where((segment) => segment.isNotEmpty).join('_');

      await _coverService.saveCoverPng(
        pngBytes: _cover!,
        fileNameWithoutExtension: fileNameWithoutExtension,
      );
    } catch (e, st) {
      setError('Failed to save cover: $e');
      debugPrint('saveCoverPng exception: $e\n$st');
    } finally {
      setBusy(false);
    }
  }

  void clearFields() {
    ebookTitleController.clear();
    authorNameController.clear();
    subtitleController.clear();
    taglineController.clear();
    seriesTitleController.clear();
    editionLineController.clear();
    cornerBadgeTextController.clear();
    _taglineTopOffset = 0;
    _seriesTitleTopOffset = 0;
    _editionLineTopOffset = 0;
    _titleTopOffset = 0;
    _authorTopOffset = 0;
    _subtitleTopOffset = 0;
    _titleTopAuthorBottomTopOffset = 0;
    _authorTopTitleCenterTopOffset = 0;
    _hasSelectedBackgroundColor = false;
    backgroundImageBytes = null;
    backgroundImageName = null;
    backgroundImageMode = BackgroundImageMode.cover;
    backgroundImageAlignment = Alignment.center;
    backgroundImageScaleX = 1;
    backgroundImageScaleY = 1;
    backgroundBlendMode = BlendMode.srcOver;
    backgroundImageOpacity = 1;
    _coverUpdateDebounce?.cancel();
    _hasPendingCoverUpdate = false;
    notifyListeners();
  }

  void _scheduleCoverUpdate() {
    _coverUpdateDebounce?.cancel();

    _coverUpdateDebounce = Timer(
      const Duration(milliseconds: 350),
      fetchCover,
    );
  }

  String? _optionalText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _normalizeFileNameSegment(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    if (normalized.isEmpty) return 'untitled';
    return normalized;
  }

  @override
  void dispose() {
    _coverUpdateDebounce?.cancel();
    ebookTitleController.removeListener(_onFieldsChanged);
    authorNameController.removeListener(_onFieldsChanged);
    subtitleController.removeListener(_onFieldsChanged);
    taglineController.removeListener(_onFieldsChanged);
    seriesTitleController.removeListener(_onFieldsChanged);
    editionLineController.removeListener(_onFieldsChanged);
    cornerBadgeTextController.removeListener(_onFieldsChanged);
    ebookTitleController.dispose();
    authorNameController.dispose();
    subtitleController.dispose();
    taglineController.dispose();
    seriesTitleController.dispose();
    editionLineController.dispose();
    cornerBadgeTextController.dispose();
    authorFocusNode.dispose();
    seriesTitleFocusNode.dispose();
    super.dispose();
  }
}
