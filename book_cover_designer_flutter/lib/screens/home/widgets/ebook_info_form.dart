import 'package:book_cover_designer_flutter/models/cover_size_preset.dart';
import 'package:book_cover_designer_flutter/models/enums.dart';
import 'package:book_cover_designer_flutter/screens/home/home_viewmodel.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_text_styles.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_tokens.dart';
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
        _QuillTextEntry(
          label: 'Ebook Title',
          controller: viewModel.titleQuillController,
          validator: () =>
              viewModel.validateEbookTitle(viewModel.ebookTitleController.text),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _LabeledColorButton(
                label: 'Box Color',
                color: viewModel.titleBoxColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('titleBox', color),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _LabeledColorButton(
                label: 'Border Color',
                color: viewModel.titleBorderColor,
                onColorSelected: (color) =>
                    viewModel.setCoverColor('titleBorder', color),
              ),
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
      ],
    );
  }

  Widget _buildEbookAuthorSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        TextRow(
          field: _QuillTextEntry(
            label: 'Author Name',
            controller: viewModel.authorQuillController,
            validator: () =>
                viewModel.validateAuthorName(viewModel.authorNameController.text),
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
      ],
    );
  }

  Widget _buildEbookSubtitleSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        TextRow(
          field: _QuillTextEntry(
            label: 'Subtitle',
            controller: viewModel.subtitleQuillController,
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
      ],
    );
  }

  Widget _buildEbookTaglineSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        OptionalTextSection(
          controller: viewModel.taglineQuillController,
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
        ),
      ],
    );
  }

  Widget _buildEbookSeriesTitleSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        TextRow(
          field: _QuillTextEntry(
            label: 'Series Title',
            controller: viewModel.seriesTitleQuillController,
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
      ],
    );
  }

  Widget _buildEbookEditionSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        OptionalTextSection(
          controller: viewModel.editionLineQuillController,
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
        ),
      ],
    );
  }

  Widget _buildEbookBadgeSection(HomeViewModel viewModel) {
    return SectionColumn(
      children: [
        TextRow(
          field: _QuillTextEntry(
            label: 'Corner Badge',
            controller: viewModel.cornerBadgeQuillController,
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
  final quill.QuillController controller;
  final String label;
  final Widget textButton,
      boxButton,
      borderButton,
      verticalSlider,
      horizontalSlider;
  final Widget? alignSelector;

  const OptionalTextSection({
    Key? key,
    required this.controller,
    required this.label,
    required this.textButton,
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
        TextRow(
          field: _QuillTextEntry(
            label: label,
            controller: controller,
          ),
          buttons: [textButton, boxButton, borderButton],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.label, style: AppTextStyles.caption(context)),
        const SizedBox(height: AppSpacing.xs),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText == null
                  ? Theme.of(context).colorScheme.outline
                  : Theme.of(context).colorScheme.error,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              quill.QuillSimpleToolbar(
                controller: widget.controller,
                config: quill.QuillSimpleToolbarConfig(
                  showUndo: false,
                  showRedo: false,
                  showAlignmentButtons: true,
                  showJustifyAlignment: true,
                  showFontFamily: true,
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
                      customOnPressedCallback: (controller, isBackground) =>
                          _showQuillColorPicker(
                            context: context,
                            controller: controller,
                            isBackground: isBackground,
                          ),
                    ),
                    backgroundColor: quill.QuillToolbarColorButtonOptions(
                      customOnPressedCallback: (controller, isBackground) =>
                          _showQuillColorPicker(
                            context: context,
                            controller: controller,
                            isBackground: isBackground,
                          ),
                    ),
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
