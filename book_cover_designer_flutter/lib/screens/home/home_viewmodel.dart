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

  ByteData? _cover;
  ByteData? get cover => _cover;
  CoverLayout _selectedLayout = CoverLayout.bigCenterTitle;
  CoverLayout get selectedLayout => _selectedLayout;

  // Optional: keep these if you use them elsewhere
  String ebookTitle = '';
  String authorName = '';

  HomeViewModel() {
    // Keep VM state in sync with controllers and recompute validity on every edit
    ebookTitleController.addListener(_onFieldsChanged);
    authorNameController.addListener(_onFieldsChanged);
  }

// SegmentedButton expects a Set
  Set<CoverLayout> get selectedLayoutSet => {_selectedLayout};

  void setSelectedLayout(CoverLayout value) {
    if (_selectedLayout == value) return;
    _selectedLayout = value;
    notifyListeners();
  }

  void _onFieldsChanged() {
    ebookTitle = ebookTitleController.text;
    authorName = authorNameController.text;
    notifyListeners(); // makes isFormValid reactive
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
    if (isBusy) return;
    setBusy(true);
    try {
      final result = await _coverService.generateImage(
        coverWidth: coverWidth,
        coverHeight: coverHeight,
        numColors: 8,
        random: Random(),
        title: ebookTitleController.text,
        author: authorNameController.text,
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
    }
  }

  Future<void> saveCover() async {
    if (isBusy) return;
    setBusy(true);
    try {
      if (_cover == null) {
        setError('Failed to save cover: null cover');
      }

      await _coverService.saveCoverPng(
        pngBytes: _cover!,
        fileNameWithoutExtension: 'ebook_cover_${DateTime.now().millisecondsSinceEpoch}',
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
    notifyListeners();
  }

  @override
  void dispose() {
    ebookTitleController.removeListener(_onFieldsChanged);
    authorNameController.removeListener(_onFieldsChanged);
    ebookTitleController.dispose();
    authorNameController.dispose();
    super.dispose();
  }
}
