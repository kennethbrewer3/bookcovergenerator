import 'dart:async';
import 'dart:typed_data';

import 'package:book_cover_designer_flutter/app/app.locator.dart';
import 'package:book_cover_designer_flutter/services/generate_ebook_cover_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

enum HomeFormSection {
  background,
  ebookDetails,
  layout,
  actions,
}

class HomeViewModel extends BaseViewModel {
  static const coverWidth = 600.0;
  static const coverHeight = 800.0;

  // ---- validation rules ----
  static const int minTitleLength = 3;
  static const int minAuthorLength = 2;

  final _coverService = locator<GenerateEbookCoverService>();
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

  final ebookTitleController = TextEditingController();
  final authorNameController = TextEditingController();
  final subtitleController = TextEditingController();
  final taglineController = TextEditingController();
  final seriesTitleController = TextEditingController();
  final editionLineController = TextEditingController();
  final cornerBadgeTextController = TextEditingController();

  ByteData? _cover;
  ByteData? get cover => _cover;
  CoverLayout _selectedLayout = CoverLayout.bigCenterTitle;
  CoverLayout get selectedLayout => _selectedLayout;
  CornerBadgePosition _selectedCornerBadgePosition = CornerBadgePosition.topRight;
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
    backgroundImageBytes = null;
    backgroundImageName = null;
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

  bool get canPreviewCover =>
      _hasSelectedBackgroundColor ||
          backgroundImageBytes != null ||
          ebookTitleController.text.trim().isNotEmpty ||
          authorNameController.text.trim().isNotEmpty;

  Future<void> fetchCover() async {
    if (!canPreviewCover) return;
    if (isBusy) {
      _hasPendingCoverUpdate = true;
      return;
    }
    setBusy(true);
    try {
      _hasPendingCoverUpdate = false;
      final result = await _coverService.generateImage(
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
      if (_hasPendingCoverUpdate && canPreviewCover) {
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
    if (!canPreviewCover) return;
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
    super.dispose();
  }
}
