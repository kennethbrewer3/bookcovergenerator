import 'package:book_cover_designer_flutter/app/app_services.dart';
import 'package:book_cover_designer_flutter/l10n/app_localizations.dart';
import 'package:book_cover_designer_flutter/models/cover_size_preset.dart';
import 'package:book_cover_designer_flutter/models/enums.dart';
import 'package:book_cover_designer_flutter/screens/home/home_viewmodel.dart';
import 'package:book_cover_designer_flutter/services/cover_fonts.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_text_styles.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_tokens.dart';
import 'package:book_cover_designer_flutter/ui/widgets/cover_font_family_button.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:stacked/stacked.dart';

class EbookInfoForm extends ViewModelWidget<HomeViewModel> {
  EbookInfoForm({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final canSubmit = !viewModel.isBusy;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                final section = HomeFormSection.values[index];
                viewModel.setFormSectionExpanded(section, isExpanded);
              },
              children: [
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.background,
                  title: l10n.sectionBackground,
                  body: _buildBackgroundSection(context, viewModel, l10n),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.title,
                  title: l10n.sectionTitle,
                  body: _buildEbookTitleSection(context, viewModel, l10n),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.author,
                  title: l10n.sectionAuthor,
                  body: _buildEbookAuthorSection(context, viewModel, l10n),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.subtitle,
                  title: l10n.sectionSubtitle,
                  body: _buildEbookSubtitleSection(context, viewModel, l10n),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.tagline,
                  title: l10n.sectionTagline,
                  body: _buildEbookTaglineSection(context, viewModel, l10n),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.series,
                  title: l10n.sectionSeries,
                  body: _buildEbookSeriesTitleSection(context, viewModel, l10n),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.edition,
                  title: l10n.sectionEdition,
                  body: _buildEbookEditionSection(context, viewModel, l10n),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.badge,
                  title: l10n.sectionBadge,
                  body: _buildEbookBadgeSection(context, viewModel, l10n),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.layout,
                  title: l10n.sectionLayout,
                  body: _buildLayoutSection(context, viewModel, l10n),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.actions,
                  title: l10n.sectionActions,
                  body: _buildActionsSection(context, viewModel, canSubmit, l10n),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ExpansionPanel _buildPanel({
    required BuildContext context,
    required HomeViewModel viewModel,
    required HomeFormSection section,
    required String title,
    required Widget body,
  }) {
    return ExpansionPanel(
      isExpanded: viewModel.isFormSectionExpanded(section),
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) => ListTile(
        title: Text(title, style: AppTextStyles.h3(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: body,
      ),
    );
  }

  Widget _buildBackgroundSection(BuildContext context, HomeViewModel viewModel, AppLocalizations l10n) {
    return SectionColumn(
      spacing: AppSpacing.xs,
      children: [
        DropdownButtonFormField<CoverSizePreset>(
          value: viewModel.selectedCoverSizePreset,
          decoration: InputDecoration(
            labelText: l10n.coverSizeLabel,
            border: const OutlineInputBorder(),
          ),
          items: viewModel.coverSizePresets
              .map(
                (preset) => DropdownMenuItem(
                  value: preset,
                  child: Text(preset.label),
                ),
              )
              .toList(),
          onChanged: (preset) {
            if (preset != null) {
              viewModel.setCoverSizePreset(preset);
            }
          },
        ),
        Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: _LabeledColorButton(
                label: l10n.btnChooseBackgroundColor,
                color: viewModel.backgroundColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('background', color),
              ),
            ),
            Expanded(
              child: FilledButton.icon(
                onPressed: viewModel.pickBackgroundImage,
                icon: const Icon(Icons.image),
                label: Text(l10n.btnChooseBackgroundImage),
              ),
            ),
          ],
        ),
        if (viewModel.backgroundImageBytes != null)
          OutlinedButton.icon(
            onPressed: viewModel.clearBackgroundImage,
            icon: const Icon(Icons.clear),
            label: Text(l10n.btnClearImage),
          ),
        if (viewModel.backgroundImageName != null)
          Text(viewModel.backgroundImageName!),
        DropdownButtonFormField<BackgroundImageMode>(
          value: viewModel.backgroundImageMode,
          decoration: InputDecoration(
            labelText: l10n.backgroundImageMode,
            border: const OutlineInputBorder(),
          ),
          items: BackgroundImageMode.values
              .map(
                (mode) => DropdownMenuItem(
                  value: mode,
                  child: Text(_backgroundImageModeLabel(mode, l10n)),
                ),
              )
              .toList(),
          onChanged: (mode) {
            if (mode != null) viewModel.setBackgroundImageMode(mode);
          },
        ),
        DropdownButtonFormField<Alignment>(
          value: viewModel.backgroundImageAlignment,
          decoration: InputDecoration(
            labelText: l10n.backgroundImageAlignment,
            border: const OutlineInputBorder(),
          ),
          items: _backgroundAlignments(l10n).entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.value,
                  child: Text(entry.key),
                ),
              )
              .toList(),
          onChanged: (alignment) {
            if (alignment != null)
              viewModel.setBackgroundImageAlignment(alignment);
          },
        ),
        _TopOffsetSlider(
          label: l10n.backgroundImageScaleX,
          value: viewModel.backgroundImageScaleX,
          min: 0.1,
          max: 4,
          divisions: 39,
          onChanged: viewModel.setBackgroundImageScaleX,
        ),
        _TopOffsetSlider(
          label: l10n.backgroundImageScaleY,
          value: viewModel.backgroundImageScaleY,
          min: 0.1,
          max: 4,
          divisions: 39,
          onChanged: viewModel.setBackgroundImageScaleY,
        ),
        DropdownButtonFormField<BlendMode>(
          value: viewModel.backgroundBlendMode,
          decoration: InputDecoration(
            labelText: l10n.backgroundMixMode,
            border: const OutlineInputBorder(),
          ),
          items: _backgroundBlendModes(l10n).entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.value,
                  child: Text(entry.key),
                ),
              )
              .toList(),
          onChanged: (blendMode) {
            if (blendMode != null) viewModel.setBackgroundBlendMode(blendMode);
          },
        ),
        _TopOffsetSlider(
          label: l10n.backgroundImageOpacity,
          value: viewModel.backgroundImageOpacity,
          min: 0,
          max: 1,
          divisions: 20,
          onChanged: viewModel.setBackgroundImageOpacity,
        ),
      ],
    );
  }

  Widget _buildEbookTitleSection(BuildContext context, HomeViewModel viewModel, AppLocalizations l10n) {
    return SectionColumn(
      children: [
        _QuillTextEntry(
          label: l10n.fieldEbookTitle,
          controller: viewModel.titleQuillController,
          validator: () => viewModel.validateEbookTitle(
            viewModel.ebookTitleController.text,
            requiredMsg: l10n.validationTitleRequired,
            tooShortMsg: l10n.validationTitleTooShort(HomeViewModel.minTitleLength),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorTitleBox,
                color: viewModel.titleBoxColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('titleBox', color),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorTitleBorder,
                color: viewModel.titleBorderColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('titleBorder', color),
              ),
            ),
          ],
        ),
        _TopOffsetSlider(
          label: l10n.sliderTitleTopOffset,
          value: viewModel.titleTopOffset,
          onChanged: viewModel.setTitleTopOffset,
        ),
        _LeftOffsetSlider(
          label: l10n.sliderTitleHorizontalOffset,
          value: viewModel.titleHorizontalOffset,
          onChanged: viewModel.setTitleHorizontalOffset,
        ),
      ],
    );
  }

  Widget _buildEbookAuthorSection(BuildContext context, HomeViewModel viewModel, AppLocalizations l10n) {
    return SectionColumn(
      children: [
        _QuillTextEntry(
          label: l10n.fieldAuthorName,
          controller: viewModel.authorQuillController,
          validator: () => viewModel.validateAuthorName(
            viewModel.authorNameController.text,
            requiredMsg: l10n.validationAuthorRequired,
            tooShortMsg: l10n.validationAuthorTooShort(HomeViewModel.minAuthorLength),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorAuthorBox,
                color: viewModel.authorBoxColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('authorBox', color),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorAuthorBorder,
                color: viewModel.authorBorderColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('authorBorder', color),
              ),
            ),
          ],
        ),
        _TopOffsetSlider(
          label: l10n.sliderAuthorTopOffset,
          value: viewModel.authorTopOffset,
          onChanged: viewModel.setAuthorTopOffset,
        ),
        _LeftOffsetSlider(
          label: l10n.sliderAuthorLeftOffset,
          value: viewModel.authorHorizontalOffset,
          onChanged: viewModel.setAuthorHorizontalOffset,
        ),
      ],
    );
  }

  Widget _buildEbookSubtitleSection(BuildContext context, HomeViewModel viewModel, AppLocalizations l10n) {
    return SectionColumn(
      children: [
        _QuillTextEntry(
          label: l10n.fieldSubtitle,
          controller: viewModel.subtitleQuillController,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorSubtitleBox,
                color: viewModel.subtitleBoxColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('subtitleBox', color),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorSubtitleBorder,
                color: viewModel.subtitleBorderColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('subtitleBorder', color),
              ),
            ),
          ],
        ),
        _TopOffsetSlider(
          label: l10n.sliderSubtitleTopOffset,
          value: viewModel.subtitleTopOffset,
          onChanged: viewModel.setSubtitleTopOffset,
        ),
        _LeftOffsetSlider(
          label: l10n.sliderSubtitleLeftOffset,
          value: viewModel.subtitleHorizontalOffset,
          onChanged: viewModel.setSubtitleHorizontalOffset,
        ),
      ],
    );
  }

  Widget _buildEbookTaglineSection(BuildContext context, HomeViewModel viewModel, AppLocalizations l10n) {
    return SectionColumn(
      children: [
        OptionalTextSection(
          controller: viewModel.taglineQuillController,
          label: l10n.fieldTagline,
          boxButton: _LabeledColorButton(
            label: l10n.colorTaglineBox,
            color: viewModel.taglineBoxColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('taglineBox', color),
          ),
          borderButton: _LabeledColorButton(
            label: l10n.colorTaglineBorder,
            color: viewModel.taglineBorderColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('taglineBorder', color),
          ),
          verticalSlider: _TopOffsetSlider(
            label: l10n.sliderTaglineTopOffset,
            value: viewModel.taglineTopOffset,
            onChanged: viewModel.setTaglineTopOffset,
          ),
          horizontalSlider: _LeftOffsetSlider(
            label: l10n.sliderTaglineLeftOffset,
            value: viewModel.taglineHorizontalOffset,
            onChanged: viewModel.setTaglineHorizontalOffset,
          ),
        ),
      ],
    );
  }

  Widget _buildEbookSeriesTitleSection(BuildContext context, HomeViewModel viewModel, AppLocalizations l10n) {
    return SectionColumn(
      children: [
        _QuillTextEntry(
          label: l10n.fieldSeriesTitle,
          controller: viewModel.seriesTitleQuillController,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorSeriesTitleBox,
                color: viewModel.seriesTitleBoxColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('seriesTitleBox', color),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorSeriesTitleBorder,
                color: viewModel.seriesTitleBorderColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('seriesTitleBorder', color),
              ),
            ),
          ],
        ),
        _TopOffsetSlider(
          label: l10n.sliderSeriesTitleTopOffset,
          value: viewModel.seriesTitleTopOffset,
          onChanged: viewModel.setSeriesTitleTopOffset,
        ),
        _LeftOffsetSlider(
          label: l10n.sliderSeriesTitleLeftOffset,
          value: viewModel.seriesTitleHorizontalOffset,
          onChanged: viewModel.setSeriesTitleHorizontalOffset,
        ),
      ],
    );
  }

  Widget _buildEbookEditionSection(BuildContext context, HomeViewModel viewModel, AppLocalizations l10n) {
    return SectionColumn(
      children: [
        OptionalTextSection(
          controller: viewModel.editionLineQuillController,
          label: l10n.fieldEditionLine,
          boxButton: _LabeledColorButton(
            label: l10n.colorEditionLineBox,
            color: viewModel.editionLineBoxColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('editionLineBox', color),
          ),
          borderButton: _LabeledColorButton(
            label: l10n.colorEditionLineBorder,
            color: viewModel.editionLineBorderColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('editionLineBorder', color),
          ),
          verticalSlider: _TopOffsetSlider(
            label: l10n.sliderEditionLineTopOffset,
            value: viewModel.editionLineTopOffset,
            onChanged: viewModel.setEditionLineTopOffset,
          ),
          horizontalSlider: _LeftOffsetSlider(
            label: l10n.sliderEditionLineLeftOffset,
            value: viewModel.editionLineHorizontalOffset,
            onChanged: viewModel.setEditionLineHorizontalOffset,
          ),
        ),
      ],
    );
  }

  Widget _buildEbookBadgeSection(BuildContext context, HomeViewModel viewModel, AppLocalizations l10n) {
    return SectionColumn(
      children: [
        _QuillTextEntry(
          label: l10n.fieldCornerBadge,
          controller: viewModel.cornerBadgeQuillController,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorBadge,
                color: viewModel.cornerBadgeColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('cornerBadge', color),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _LabeledColorButton(
                label: l10n.colorBadgeBorder,
                color: viewModel.cornerBadgeBorderColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('cornerBadgeBorder', color),
              ),
            ),
          ],
        ),
        SegmentedButton<CornerBadgePosition>(
          showSelectedIcon: false,
          segments: <ButtonSegment<CornerBadgePosition>>[
            ButtonSegment(
              value: CornerBadgePosition.topLeft,
              icon: const Icon(Icons.north_west),
              label: Text(l10n.badgePositionTopLeft),
            ),
            ButtonSegment(
              value: CornerBadgePosition.topRight,
              icon: const Icon(Icons.north_east),
              label: Text(l10n.badgePositionTopRight),
            ),
            ButtonSegment(
              value: CornerBadgePosition.bottomLeft,
              icon: const Icon(Icons.south_west),
              label: Text(l10n.badgePositionBottomLeft),
            ),
            ButtonSegment(
              value: CornerBadgePosition.bottomRight,
              icon: const Icon(Icons.south_east),
              label: Text(l10n.badgePositionBottomRight),
            ),
          ],
          selected: viewModel.selectedCornerBadgePositionSet,
          onSelectionChanged: (selection) {
            viewModel.setSelectedCornerBadgePosition(selection.first);
            if (_formKey.currentState!.validate()) {
              viewModel.fetchCover();
            }
          },
        ),
      ],
    );
  }

  Widget _buildLayoutSection(BuildContext context, HomeViewModel viewModel, AppLocalizations l10n) {
    return SectionColumn(
      children: [
        SegmentedButton<CoverLayout>(
          showSelectedIcon: false,
          segments: <ButtonSegment<CoverLayout>>[
            ButtonSegment(
              value: CoverLayout.bigCenterTitle,
              icon: const Icon(Icons.crop_7_5),
              label: Text(l10n.layoutModern),
              tooltip: l10n.layoutModernTooltip,
            ),
            ButtonSegment(
              value: CoverLayout.titleTopAuthorBottom,
              icon: const Icon(Icons.vertical_align_top),
              label: Text(l10n.layoutTopBottom),
              tooltip: l10n.layoutTopBottomTooltip,
            ),
            ButtonSegment(
              value: CoverLayout.authorTopTitleCenter,
              icon: const Icon(Icons.vertical_align_center),
              label: Text(l10n.layoutTopCenter),
              tooltip: l10n.layoutTopCenterTooltip,
            ),
          ],
          selected: viewModel.selectedLayoutSet,
          onSelectionChanged: (selection) {
            viewModel.setSelectedLayout(selection.first);
            if (_formKey.currentState!.validate()) {
              viewModel.fetchCover();
            }
          },
        ),
        if (viewModel.selectedLayout == CoverLayout.titleTopAuthorBottom)
          _TopOffsetSlider(
            label: l10n.sliderTopBottomTopOffset,
            value: viewModel.titleTopAuthorBottomTopOffset,
            onChanged: viewModel.setTitleTopAuthorBottomTopOffset,
          ),
        if (viewModel.selectedLayout == CoverLayout.authorTopTitleCenter)
          _TopOffsetSlider(
            label: l10n.sliderTopCenterTopOffset,
            value: viewModel.authorTopTitleCenterTopOffset,
            onChanged: viewModel.setAuthorTopTitleCenterTopOffset,
          ),
      ],
    );
  }

  Widget _buildActionsSection(
    BuildContext context,
    HomeViewModel viewModel,
    bool canSubmit,
    AppLocalizations l10n,
  ) {
    return SectionColumn(
      spacing: AppSpacing.xs,
      children: [
        FilledButton(
          onPressed: canSubmit ? viewModel.fetchCover : null,
          child: Text(
            l10n.btnGenerateCover,
            style: AppTextStyles.button(context),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            _formKey.currentState?.reset();
            viewModel.clearFields();
          },
          child: Text(
            l10n.btnClearFields,
            style: AppTextStyles.button(context),
          ),
        ),
        OutlinedButton(
          onPressed:
              (viewModel.cover != null &&
                  !viewModel.isBusy &&
                  viewModel.isFormValid)
              ? viewModel.saveCover
              : null,
          child: Text(
            l10n.btnSaveCover,
            style: AppTextStyles.button(context),
          ),
        ),
      ],
    );
  }
}

class _TopOffsetSlider extends StatelessWidget {
  const _TopOffsetSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = -0.25,
    this.max = 0.25,
    this.divisions = 100,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('$label: ${(value * 100).round()}%'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: '${(value * 100).round()}%',
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _LeftOffsetSlider extends StatelessWidget {
  const _LeftOffsetSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = -0.25,
    this.max = 0.25,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('$label: ${(value * 100).toStringAsFixed(1)}%'),
        Slider(
          value: value,
          min: min,
          max: max,
          label: '${(value * 100).toStringAsFixed(1)}%',
          onChanged: onChanged,
        ),
      ],
    );
  }
}

String _backgroundImageModeLabel(BackgroundImageMode mode, AppLocalizations l10n) {
  switch (mode) {
    case BackgroundImageMode.cover:
      return l10n.imgModeCover;
    case BackgroundImageMode.contain:
      return l10n.imgModeFit;
    case BackgroundImageMode.stretch:
      return l10n.imgModeStretch;
    case BackgroundImageMode.center:
      return l10n.imgModeCenter;
    case BackgroundImageMode.tile:
      return l10n.imgModeTileXY;
    case BackgroundImageMode.tileX:
      return l10n.imgModeTileX;
    case BackgroundImageMode.tileY:
      return l10n.imgModeTileY;
  }
}

Map<String, Alignment> _backgroundAlignments(AppLocalizations l10n) => {
  l10n.alignTopLeft: Alignment.topLeft,
  l10n.alignTopCenter: Alignment.topCenter,
  l10n.alignTopRight: Alignment.topRight,
  l10n.alignCenterLeft: Alignment.centerLeft,
  l10n.alignCenter: Alignment.center,
  l10n.alignCenterRight: Alignment.centerRight,
  l10n.alignBottomLeft: Alignment.bottomLeft,
  l10n.alignBottomCenter: Alignment.bottomCenter,
  l10n.alignBottomRight: Alignment.bottomRight,
};

Map<String, BlendMode> _backgroundBlendModes(AppLocalizations l10n) => {
  l10n.blendNormal: BlendMode.srcOver,
  l10n.blendMultiply: BlendMode.multiply,
  l10n.blendScreen: BlendMode.screen,
  l10n.blendOverlay: BlendMode.overlay,
  l10n.blendDarken: BlendMode.darken,
  l10n.blendLighten: BlendMode.lighten,
  l10n.blendColorDodge: BlendMode.colorDodge,
  l10n.blendColorBurn: BlendMode.colorBurn,
  l10n.blendHardLight: BlendMode.hardLight,
  l10n.blendSoftLight: BlendMode.softLight,
  l10n.blendDifference: BlendMode.difference,
  l10n.blendExclusion: BlendMode.exclusion,
  l10n.blendHue: BlendMode.hue,
  l10n.blendSaturation: BlendMode.saturation,
  l10n.blendColor: BlendMode.color,
  l10n.blendLuminosity: BlendMode.luminosity,
};

class _LabeledColorButton extends StatelessWidget {
  const _LabeledColorButton({
    required this.label,
    required this.color,
    required this.onColorSelected,
  });

  final String label;
  final Color color;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        var selected = color;
        final confirmed = await ColorPicker(
          color: selected,
          onColorChanged: (c) => selected = c,
          width: 40,
          height: 40,
          borderRadius: 8,
          spacing: 8,
          runSpacing: 8,
          heading: Text(label),
          subheading: const Text('Select shade'),
          showMaterialName: true,
          showColorName: true,
          showColorCode: true,
          enableOpacity: true,
          pickersEnabled: const {
            ColorPickerType.both: true,
            ColorPickerType.primary: true,
            ColorPickerType.accent: true,
            ColorPickerType.bw: true,
            ColorPickerType.custom: true,
            ColorPickerType.wheel: true,
          },
        ).showPickerDialog(context);
        if (confirmed) onColorSelected(selected);
      },
      icon: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      label: Text(label),
    );
  }
}

class SectionColumn extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  const SectionColumn({Key? key, required this.children, this.spacing = AppSpacing.xs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing,
      children: children,
    );
  }
}

class OptionalTextSection extends StatelessWidget {
  final quill.QuillController controller;
  final String label;
  final Widget boxButton,
      borderButton,
      verticalSlider,
      horizontalSlider;
  final Widget? alignSelector;

  const OptionalTextSection({
    Key? key,
    required this.controller,
    required this.label,
    required this.boxButton,
    required this.borderButton,
    required this.verticalSlider,
    required this.horizontalSlider,
    this.alignSelector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionColumn(
      children: [
        _QuillTextEntry(
          label: label,
          controller: controller,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(child: boxButton),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: borderButton),
          ],
        ),
        verticalSlider,
        horizontalSlider,
        if (alignSelector != null) alignSelector!,
      ],
    );
  }
}

class _QuillTextEntry extends StatefulWidget {
  const _QuillTextEntry({
    required this.label,
    required this.controller,
    this.validator,
  });

  final String label;
  final quill.QuillController controller;
  final String? Function()? validator;

  @override
  State<_QuillTextEntry> createState() => _QuillTextEntryState();
}

class _QuillTextEntryState extends State<_QuillTextEntry> {
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  static Future<void> _showQuillColorPicker({
    required BuildContext context,
    required quill.QuillController controller,
    required bool isBackground,
  }) async {
    final currentHex = isBackground
        ? controller.getSelectionStyle().attributes['background']?.value
        : controller.getSelectionStyle().attributes['color']?.value;

    Color current = Colors.black;
    if (currentHex is String) {
      final hex = currentHex.replaceAll('#', '');
      if (hex.length == 6) {
        current = Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        current = Color(int.parse(hex, radix: 16));
      }
    }

    var selected = current;
    final confirmed = await ColorPicker(
      color: selected,
      onColorChanged: (c) => selected = c,
      width: 40,
      height: 40,
      borderRadius: 8,
      spacing: 8,
      runSpacing: 8,
      heading: Text(isBackground ? 'Background Color' : 'Text Color'),
      subheading: const Text('Select shade'),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      enableOpacity: true,
      pickersEnabled: const {
        ColorPickerType.both: true,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: true,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(context);

    if (!confirmed) return;

    int floatToInt8(double x) => (x * 255.0).round() & 0xff;
    final a = floatToInt8(selected.a);
    final r = floatToInt8(selected.r);
    final g = floatToInt8(selected.g);
    final b = floatToInt8(selected.b);
    final hex =
        '#${a.toRadixString(16).padLeft(2, '0')}${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'
            .toUpperCase();

    controller.formatSelection(
      isBackground
          ? quill.BackgroundAttribute(hex)
          : quill.ColorAttribute(hex),
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorText = widget.validator?.call();
    final l10n = AppLocalizations.of(context)!;
    final quillL10n = quill.FlutterQuillLocalizations.of(context);
    const toolbarSectionHeight = quill.kDefaultToolbarSize + AppSpacing.xs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.label, style: AppTextStyles.caption(context)),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText == null
                  ? Theme.of(context).colorScheme.outline
                  : Theme.of(context).colorScheme.error,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: errorText == null
                          ? Theme.of(context).colorScheme.outline
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                child: SizedBox(
                  height: toolbarSectionHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListenableBuilder(
                        listenable: customFontService.fonts,
                        builder: (context, _) {
                          final fontFamilyItems = CoverFonts.fontFamilyItems(
                            clearLabel: l10n.fontClear,
                            customFonts: customFontService.fonts.value,
                          );

                          return ListenableBuilder(
                            listenable: widget.controller,
                            builder: (context, _) {
                              return CoverFontFamilyButton(
                                controller: widget.controller,
                                items: fontFamilyItems,
                                defaultLabel: quillL10n?.font ?? 'Font',
                                toolbarHeight: toolbarSectionHeight,
                              );
                            },
                          );
                        },
                      ),
                      const quill.QuillToolbarDivider.vertical(),
                      Expanded(
                        child: quill.QuillSimpleToolbar(
                          controller: widget.controller,
                          config: quill.QuillSimpleToolbarConfig(
                            multiRowsDisplay: false,
                            toolbarSize: toolbarSectionHeight,
                            color: Colors.transparent,
                            decoration: const BoxDecoration(),
                            showUndo: false,
                            showRedo: false,
                            showAlignmentButtons: true,
                            showJustifyAlignment: true,
                            showFontFamily: false,
                            showFontSize: true,
                            showBackgroundColorButton: true,
                            showColorButton: true,
                            showSearchButton: false,
                            showCodeBlock: false,
                            showQuote: false,
                            showInlineCode: false,
                            showLink: false,
                            showListBullets: false,
                            showListNumbers: false,
                            showListCheck: false,
                            showIndent: false,
                            showSubscript: true,
                            showSuperscript: true,
                            showHeaderStyle: false,
                            showDividers: false,
                            buttonOptions: quill.QuillSimpleToolbarButtonOptions(
                              color: quill.QuillToolbarColorButtonOptions(
                                customOnPressedCallback:
                                    (controller, isBackground) =>
                                        _showQuillColorPicker(
                                          context: context,
                                          controller: controller,
                                          isBackground: isBackground,
                                        ),
                              ),
                              backgroundColor:
                                  quill.QuillToolbarColorButtonOptions(
                                customOnPressedCallback:
                                    (controller, isBackground) =>
                                        _showQuillColorPicker(
                                          context: context,
                                          controller: controller,
                                          isBackground: isBackground,
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _focusNode.requestFocus(),
                child: SizedBox(
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: quill.QuillEditor.basic(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      scrollController: _scrollController,
                      config: const quill.QuillEditorConfig(
                        placeholder: 'Enter text',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class TextRow extends StatelessWidget {
  final Widget field;
  final List<Widget> buttons;

  TextRow({required this.field, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: field),
        ...buttons,
      ],
    );
  }
}
