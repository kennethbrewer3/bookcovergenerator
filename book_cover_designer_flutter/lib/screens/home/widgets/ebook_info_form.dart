import 'package:book_cover_designer_flutter/models/cover_size_preset.dart';
import 'package:book_cover_designer_flutter/models/enums.dart';
import 'package:book_cover_designer_flutter/screens/home/home_viewmodel.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_text_styles.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_tokens.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EbookInfoForm extends ViewModelWidget<HomeViewModel> {
  EbookInfoForm({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final canSubmit = !viewModel.isBusy;

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
                  title: 'Background Color and Image',
                  body: _buildBackgroundSection(viewModel),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.title,
                  title: 'Title',
                  body: _buildEbookTitleSection(viewModel),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.author,
                  title: 'Author',
                  body: _buildEbookAuthorSection(viewModel),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.subtitle,
                  title: 'Subtitle',
                  body: _buildEbookSubtitleSection(viewModel),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.tagline,
                  title: 'Tagline',
                  body: _buildEbookTaglineSection(viewModel),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.series,
                  title: 'Series Title',
                  body: _buildEbookSeriesTitleSection(viewModel),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.edition,
                  title: 'Edition',
                  body: _buildEbookEditionSection(viewModel),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.badge,
                  title: 'Corner  Badge',
                  body: _buildEbookBadgeSection(viewModel),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.layout,
                  title: 'Cover Layout',
                  body: _buildLayoutSection(viewModel),
                ),
                _buildPanel(
                  context: context,
                  viewModel: viewModel,
                  section: HomeFormSection.actions,
                  title: 'Actions',
                  body: _buildActionsSection(context, viewModel, canSubmit),
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
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: body,
      ),
    );
  }

  Widget _buildBackgroundSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        Row(
          spacing: AppSpacing.md,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ColorButton(
              label: 'Background Color',
              color: viewModel.backgroundColor,
              width: 80,
              height: 50,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('background', color),
            ),
            Expanded(
              child: DropdownButtonFormField<CoverSizePreset>(
                value: viewModel.selectedCoverSizePreset,
                decoration: const InputDecoration(
                  labelText: 'Cover Size',
                  border: OutlineInputBorder(),
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
            ),
          ],
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: viewModel.pickBackgroundImage,
              icon: const Icon(Icons.image),
              label: const Text('Choose Background Image'),
            ),
            if (viewModel.backgroundImageBytes != null)
              OutlinedButton.icon(
                onPressed: viewModel.clearBackgroundImage,
                icon: const Icon(Icons.clear),
                label: const Text('Clear Image'),
              ),
            if (viewModel.backgroundImageName != null)
              Text(viewModel.backgroundImageName!),
          ],
        ),
        DropdownButtonFormField<BackgroundImageMode>(
          value: viewModel.backgroundImageMode,
          decoration: const InputDecoration(
            labelText: 'Background Image Mode',
            border: OutlineInputBorder(),
          ),
          items: BackgroundImageMode.values
              .map(
                (mode) => DropdownMenuItem(
                  value: mode,
                  child: Text(_backgroundImageModeLabel(mode)),
                ),
              )
              .toList(),
          onChanged: (mode) {
            if (mode != null) viewModel.setBackgroundImageMode(mode);
          },
        ),
        DropdownButtonFormField<Alignment>(
          value: viewModel.backgroundImageAlignment,
          decoration: const InputDecoration(
            labelText: 'Background Image Alignment',
            border: OutlineInputBorder(),
          ),
          items: _backgroundAlignments.entries
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
          label: 'Background Image Scale X',
          value: viewModel.backgroundImageScaleX,
          min: 0.1,
          max: 4,
          divisions: 39,
          onChanged: viewModel.setBackgroundImageScaleX,
        ),
        _TopOffsetSlider(
          label: 'Background Image Scale Y',
          value: viewModel.backgroundImageScaleY,
          min: 0.1,
          max: 4,
          divisions: 39,
          onChanged: viewModel.setBackgroundImageScaleY,
        ),
        DropdownButtonFormField<BlendMode>(
          value: viewModel.backgroundBlendMode,
          decoration: const InputDecoration(
            labelText: 'Background Mix Mode',
            border: OutlineInputBorder(),
          ),
          items: _backgroundBlendModes.entries
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
          label: 'Background Image Opacity',
          value: viewModel.backgroundImageOpacity,
          min: 0,
          max: 1,
          divisions: 20,
          onChanged: viewModel.setBackgroundImageOpacity,
        ),
      ],
    );
  }

  Widget _buildEbookTitleSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        TextRow(
          field: TextFormField(
            controller: viewModel.ebookTitleController,
            decoration: const InputDecoration(
              labelText: 'Ebook Title',
              border: OutlineInputBorder(),
            ),
            validator: viewModel.validateEbookTitle,
          ),
          buttons: [
            _ColorButton(
              label: 'Title Text Color',
              color: viewModel.titleTextColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('titleText', color),
            ),
            _ColorButton(
              label: 'Title Box Color',
              color: viewModel.titleBoxColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('titleBox', color),
            ),
            _ColorButton(
              label: 'Title Border Color',
              color: viewModel.titleBorderColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('titleBorder', color),
            ),
          ],
        ),
        _TopOffsetSlider(
          label: 'Title Top Offset',
          value: viewModel.titleTopOffset,
          onChanged: viewModel.setTitleTopOffset,
        ),
        _LeftOffsetSlider(
          label: 'Title Horizontal Offset',
          value: viewModel.titleHorizontalOffset,
          onChanged: viewModel.setTitleHorizontalOffset,
        ),
        _TextAlignSelector(
          label: 'Title Justification',
          value: viewModel.titleTextAlign,
          onChanged: viewModel.setTitleTextAlign,
        ),
      ],
    );
  }

  Widget _buildEbookAuthorSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        TextRow(
          field: TextFormField(
            controller: viewModel.authorNameController,
            decoration: const InputDecoration(
              labelText: 'Author Name',
              border: OutlineInputBorder(),
            ),
            validator: viewModel.validateAuthorName,
          ),
          buttons: [
            _ColorButton(
              label: 'Author Text Color',
              color: viewModel.authorTextColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('authorText', color),
            ),
            _ColorButton(
              label: 'Author Box Color',
              color: viewModel.authorBoxColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('authorBox', color),
            ),
            _ColorButton(
              label: 'Author Border Color',
              color: viewModel.authorBorderColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('authorBorder', color),
            ),
          ],
        ),
        _TopOffsetSlider(
          label: 'Author Top Offset',
          value: viewModel.authorTopOffset,
          onChanged: viewModel.setAuthorTopOffset,
        ),
        _LeftOffsetSlider(
          label: 'Author Left Offset',
          value: viewModel.authorHorizontalOffset,
          onChanged: viewModel.setAuthorHorizontalOffset,
        ),
        _TextAlignSelector(
          label: 'Author Justification',
          value: viewModel.authorTextAlign,
          onChanged: viewModel.setAuthorTextAlign,
        ),
      ],
    );
  }

  Widget _buildEbookSubtitleSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        TextRow(
          field: TextFormField(
            controller: viewModel.subtitleController,
            decoration: const InputDecoration(
              labelText: 'Subtitle',
              border: OutlineInputBorder(),
            ),
          ),
          buttons: [
            _ColorButton(
              label: 'Subtitle Text Color',
              color: viewModel.subtitleTextColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('subtitleText', color),
            ),
            _ColorButton(
              label: 'Subtitle Box Color',
              color: viewModel.subtitleBoxColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('subtitleBox', color),
            ),
            _ColorButton(
              label: 'Subtitle Border Color',
              color: viewModel.subtitleBorderColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('subtitleBorder', color),
            ),
          ],
        ),
        _TopOffsetSlider(
          label: 'Subtitle Top Offset',
          value: viewModel.subtitleTopOffset,
          onChanged: viewModel.setSubtitleTopOffset,
        ),
        _LeftOffsetSlider(
          label: 'Subtitle Left Offset',
          value: viewModel.subtitleHorizontalOffset,
          onChanged: viewModel.setSubtitleHorizontalOffset,
        ),
        _TextAlignSelector(
          label: 'Subtitle Justification',
          value: viewModel.subtitleTextAlign,
          onChanged: viewModel.setSubtitleTextAlign,
        ),
      ],
    );
  }

  Widget _buildEbookTaglineSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        OptionalTextSection(
          controller: viewModel.taglineController,
          label: 'Tagline',
          textButton: _ColorButton(
            label: 'Tagline Text Color',
            color: viewModel.taglineTextColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('taglineText', color),
          ),
          boxButton: _ColorButton(
            label: 'Tagline Box Color',
            color: viewModel.taglineBoxColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('taglineBox', color),
          ),
          borderButton: _ColorButton(
            label: 'Tagline Border Color',
            color: viewModel.taglineBorderColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('taglineBorder', color),
          ),
          verticalSlider: _TopOffsetSlider(
            label: 'Tagline Top Offset',
            value: viewModel.taglineTopOffset,
            onChanged: viewModel.setTaglineTopOffset,
          ),
          horizontalSlider: _LeftOffsetSlider(
            label: 'Tagline Left Offset',
            value: viewModel.taglineHorizontalOffset,
            onChanged: viewModel.setTaglineHorizontalOffset,
          ),
          alignSelector: _TextAlignSelector(
            label: 'Tagline Justification',
            value: viewModel.taglineTextAlign,
            onChanged: viewModel.setTaglineTextAlign,
          ),
        ),
      ],
    );
  }

  Widget _buildEbookSeriesTitleSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        TextRow(
          field: TextFormField(
            controller: viewModel.seriesTitleController,
            decoration: const InputDecoration(
              labelText: 'Series Title',
              border: OutlineInputBorder(),
            ),
          ),
          buttons: [
            _ColorButton(
              label: 'Series Title Text Color',
              color: viewModel.seriesTitleTextColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('seriesTitleText', color),
            ),
            _ColorButton(
              label: 'Series Title Box Color',
              color: viewModel.seriesTitleBoxColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('seriesTitleBox', color),
            ),
            _ColorButton(
              label: 'Series Title Border Color',
              color: viewModel.seriesTitleBorderColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('seriesTitleBorder', color),
            ),
          ],
        ),
        _TopOffsetSlider(
          label: 'Series Title Top Offset',
          value: viewModel.seriesTitleTopOffset,
          onChanged: viewModel.setSeriesTitleTopOffset,
        ),
        _LeftOffsetSlider(
          label: 'Series Title Left Offset',
          value: viewModel.seriesTitleHorizontalOffset,
          onChanged: viewModel.setSeriesTitleHorizontalOffset,
        ),
        _TextAlignSelector(
          label: 'Series Title Justification',
          value: viewModel.seriesTitleTextAlign,
          onChanged: viewModel.setSeriesTitleTextAlign,
        ),
      ],
    );
  }

  Widget _buildEbookEditionSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        OptionalTextSection(
          controller: viewModel.editionLineController,
          label: 'Edition Line',
          textButton: _ColorButton(
            label: 'Edition Line Text Color',
            color: viewModel.editionLineTextColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('editionLineText', color),
          ),
          boxButton: _ColorButton(
            label: 'Edition Line Box Color',
            color: viewModel.editionLineBoxColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('editionLineBox', color),
          ),
          borderButton: _ColorButton(
            label: 'Edition Line Border Color',
            color: viewModel.editionLineBorderColor,
            onColorSelected: (color) =>
                viewModel.setCoverColor('editionLineBorder', color),
          ),
          verticalSlider: _TopOffsetSlider(
            label: 'Edition Line Top Offset',
            value: viewModel.editionLineTopOffset,
            onChanged: viewModel.setEditionLineTopOffset,
          ),
          horizontalSlider: _LeftOffsetSlider(
            label: 'Edition Line Left Offset',
            value: viewModel.editionLineHorizontalOffset,
            onChanged: viewModel.setEditionLineHorizontalOffset,
          ),
          alignSelector: _TextAlignSelector(
            label: 'Edition Line Justification',
            value: viewModel.editionLineTextAlign,
            onChanged: viewModel.setEditionLineTextAlign,
          ),
        ),
      ],
    );
  }

  Widget _buildEbookBadgeSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        TextRow(
          field: TextFormField(
            controller: viewModel.cornerBadgeTextController,
            decoration: const InputDecoration(
              labelText: 'Corner Badge',
              border: OutlineInputBorder(),
            ),
          ),
          buttons: [
            _ColorButton(
              label: 'Badge Text Color',
              color: viewModel.cornerBadgeTextColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('cornerBadgeText', color),
            ),
            _ColorButton(
              label: 'Badge Color',
              color: viewModel.cornerBadgeColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('cornerBadge', color),
            ),
            _ColorButton(
              label: 'Badge Border Color',
              color: viewModel.cornerBadgeBorderColor,
              onColorSelected: (color) =>
                  viewModel.setCoverColor('cornerBadgeBorder', color),
            ),
          ],
        ),
        _TextAlignSelector(
          label: 'Badge Justification',
          value: viewModel.cornerBadgeTextAlign,
          onChanged: viewModel.setCornerBadgeTextAlign,
        ),
        SegmentedButton<CornerBadgePosition>(
          showSelectedIcon: false,
          segments: const <ButtonSegment<CornerBadgePosition>>[
            ButtonSegment(
              value: CornerBadgePosition.topLeft,
              icon: Icon(Icons.north_west),
              label: Text('Top Left'),
            ),
            ButtonSegment(
              value: CornerBadgePosition.topRight,
              icon: Icon(Icons.north_east),
              label: Text('Top Right'),
            ),
            ButtonSegment(
              value: CornerBadgePosition.bottomLeft,
              icon: Icon(Icons.south_west),
              label: Text('Bottom Left'),
            ),
            ButtonSegment(
              value: CornerBadgePosition.bottomRight,
              icon: Icon(Icons.south_east),
              label: Text('Bottom Right'),
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

  Widget _buildLayoutSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        SegmentedButton<CoverLayout>(
          showSelectedIcon: false,
          segments: const <ButtonSegment<CoverLayout>>[
            ButtonSegment(
              value: CoverLayout.bigCenterTitle,
              icon: Icon(Icons.crop_7_5),
              label: Text('Modern'),
              tooltip: 'Big centered title layout',
            ),
            ButtonSegment(
              value: CoverLayout.titleTopAuthorBottom,
              icon: Icon(Icons.vertical_align_top),
              label: Text('Top / Bottom'),
              tooltip: 'Title near top, author near bottom',
            ),
            ButtonSegment(
              value: CoverLayout.authorTopTitleCenter,
              icon: Icon(Icons.vertical_align_center),
              label: Text('Top / Center'),
              tooltip: 'Author near top, title centered',
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
            label: 'Top / Bottom Top Offset',
            value: viewModel.titleTopAuthorBottomTopOffset,
            onChanged: viewModel.setTitleTopAuthorBottomTopOffset,
          ),
        if (viewModel.selectedLayout == CoverLayout.authorTopTitleCenter)
          _TopOffsetSlider(
            label: 'Top / Center Top Offset',
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
  ) {
    return SectionColumn(
      children: [
        FilledButton(
          onPressed: canSubmit ? viewModel.fetchCover : null,
          child: Text(
            'Generate Cover',
            style: AppTextStyles.button(context),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            _formKey.currentState?.reset();
            viewModel.clearFields();
          },
          child: Text(
            'Clear Fields',
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
            'Save Cover',
            style: AppTextStyles.button(context),
          ),
        ),
      ],
    );
  }
}

class _TextAlignSelector extends StatelessWidget {
  const _TextAlignSelector({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final TextAlign value;
  final ValueChanged<TextAlign> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption(context)),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<TextAlign>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: TextAlign.left,
              icon: Icon(Icons.format_align_left),
              label: Text('Left'),
            ),
            ButtonSegment(
              value: TextAlign.center,
              icon: Icon(Icons.format_align_center),
              label: Text('Center'),
            ),
            ButtonSegment(
              value: TextAlign.right,
              icon: Icon(Icons.format_align_right),
              label: Text('Right'),
            ),
            ButtonSegment(
              value: TextAlign.justify,
              icon: Icon(Icons.format_align_justify),
              label: Text('Justify'),
            ),
          ],
          selected: {value},
          onSelectionChanged: (selection) => onChanged(selection.first),
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

String _backgroundImageModeLabel(BackgroundImageMode mode) {
  switch (mode) {
    case BackgroundImageMode.cover:
      return 'Cover';
    case BackgroundImageMode.contain:
      return 'Fit';
    case BackgroundImageMode.stretch:
      return 'Stretch';
    case BackgroundImageMode.center:
      return 'Center';
    case BackgroundImageMode.tile:
      return 'Tile X and Y';
    case BackgroundImageMode.tileX:
      return 'Tile X';
    case BackgroundImageMode.tileY:
      return 'Tile Y';
  }
}

const _backgroundAlignments = {
  'Top Left': Alignment.topLeft,
  'Top Center': Alignment.topCenter,
  'Top Right': Alignment.topRight,
  'Center Left': Alignment.centerLeft,
  'Center': Alignment.center,
  'Center Right': Alignment.centerRight,
  'Bottom Left': Alignment.bottomLeft,
  'Bottom Center': Alignment.bottomCenter,
  'Bottom Right': Alignment.bottomRight,
};

const _backgroundBlendModes = {
  'Normal': BlendMode.srcOver,
  'Multiply': BlendMode.multiply,
  'Screen': BlendMode.screen,
  'Overlay': BlendMode.overlay,
  'Darken': BlendMode.darken,
  'Lighten': BlendMode.lighten,
  'Color Dodge': BlendMode.colorDodge,
  'Color Burn': BlendMode.colorBurn,
  'Hard Light': BlendMode.hardLight,
  'Soft Light': BlendMode.softLight,
  'Difference': BlendMode.difference,
  'Exclusion': BlendMode.exclusion,
  'Hue': BlendMode.hue,
  'Saturation': BlendMode.saturation,
  'Color': BlendMode.color,
  'Luminosity': BlendMode.luminosity,
};

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    required this.label,
    required this.color,
    required this.onColorSelected,
    this.width = 22,
    this.height = 22,
  });

  final String label;
  final Color color;
  final ValueChanged<Color> onColorSelected;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: IconButton(
        onPressed: () async {
          var selected = color;
          final confirmed =
              await ColorPicker(
                color: selected,
                onColorChanged: (newColor) => selected = newColor,
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
              ).showPickerDialog(
                context,
              );

          if (confirmed) {
            onColorSelected(selected);
          }
        },
        icon: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}

class SectionColumn extends StatelessWidget {
  final List<Widget> children;
  const SectionColumn({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class OptionalTextSection extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget textButton,
      boxButton,
      borderButton,
      verticalSlider,
      horizontalSlider,
      alignSelector;

  const OptionalTextSection({
    Key? key,
    required this.controller,
    required this.label,
    required this.textButton,
    required this.boxButton,
    required this.borderButton,
    required this.verticalSlider,
    required this.horizontalSlider,
    required this.alignSelector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionColumn(
      children: [
        TextRow(
          field: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
          buttons: [textButton, boxButton, borderButton],
        ),
        verticalSlider,
        horizontalSlider,
        alignSelector,
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
