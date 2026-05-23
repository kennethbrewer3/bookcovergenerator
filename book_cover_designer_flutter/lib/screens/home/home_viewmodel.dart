import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:book_cover_designer_flutter/app/app.locator.dart';
import 'package:book_cover_designer_flutter/services/generate_ebook_cover_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  static const coverWidth = 400.0;
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
    if (!isFormValid) return;
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
        numColors: 8,
        random: Random(),
        title: ebookTitleController.text,
        author: authorNameController.text,
        subtitle: _optionalText(subtitleController.text),
        tagline: _optionalText(taglineController.text),
        seriesTitle: _optionalText(seriesTitleController.text),
        editionLine: _optionalText(editionLineController.text),
        taglineTopOffset: taglineTopOffset,
        seriesTitleTopOffset: seriesTitleTopOffset,
        editionLineTopOffset: editionLineTopOffset,
        cornerBadgeText: _optionalText(cornerBadgeTextController.text),
        cornerBadgePosition: selectedCornerBadgePosition,
        layout: selectedLayout,
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
      if (_hasPendingCoverUpdate && isFormValid) {
        _scheduleCoverUpdate();
      }
    }
  }

  Future<void> saveCover() async {
    if (isBusy) return;
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
    _coverUpdateDebounce?.cancel();
    _hasPendingCoverUpdate = false;
    notifyListeners();
  }

  void _scheduleCoverUpdate() {
    _coverUpdateDebounce?.cancel();
    if (!isFormValid) return;
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
