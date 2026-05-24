import 'package:book_cover_designer_flutter/screens/home/home_viewmodel.dart';
import 'package:book_cover_designer_flutter/services/generate_ebook_cover_service.dart';
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
    final canSubmit = !viewModel.isBusy && viewModel.isFormValid;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Column(
            spacing: AppSpacing.md,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ebook Details',
                style: AppTextStyles.h1(context),
              ),
              Text(
                'Background Color and Image',
                style: AppTextStyles.h3(context),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: _ColorButton(
                  label: 'Background Color',
                  color: viewModel.backgroundColor,
                  onColorSelected: (color) => viewModel.setCoverColor('background', color),
                ),
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
                decoration: const InputDecoration(labelText: 'Background Image Mode', border: OutlineInputBorder()),
                items: BackgroundImageMode.values
                    .map((mode) => DropdownMenuItem(value: mode, child: Text(_backgroundImageModeLabel(mode))))
                    .toList(),
                onChanged: (mode) {
                  if (mode != null) viewModel.setBackgroundImageMode(mode);
                },
              ),
              DropdownButtonFormField<Alignment>(
                value: viewModel.backgroundImageAlignment,
                decoration: const InputDecoration(labelText: 'Background Image Alignment', border: OutlineInputBorder()),
                items: _backgroundAlignments.entries
                    .map((entry) => DropdownMenuItem(value: entry.value, child: Text(entry.key)))
                    .toList(),
                onChanged: (alignment) {
                  if (alignment != null) viewModel.setBackgroundImageAlignment(alignment);
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
                decoration: const InputDecoration(labelText: 'Background Mix Mode', border: OutlineInputBorder()),
                items: _backgroundBlendModes.entries
                    .map((entry) => DropdownMenuItem(value: entry.value, child: Text(entry.key)))
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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.ebookTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Ebook Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: viewModel.validateEbookTitle,
                      // onChanged not required now, controllers listeners handle it
                    ),
                  ),
                  _ColorButton(label: 'Title Text Color', color: viewModel.titleTextColor, onColorSelected: (color) => viewModel.setCoverColor('titleText', color)),
                  _ColorButton(label: 'Title Box Color', color: viewModel.titleBoxColor, onColorSelected: (color) => viewModel.setCoverColor('titleBox', color)),
                ],
              ),
              _TopOffsetSlider(
                label: 'Title Top Offset',
                value: viewModel.titleTopOffset,
                onChanged: viewModel.setTitleTopOffset,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.authorNameController,
                      decoration: const InputDecoration(
                        labelText: 'Author Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: viewModel.validateAuthorName,
                    ),
                  ),
                  _ColorButton(label: 'Author Text Color', color: viewModel.authorTextColor, onColorSelected: (color) => viewModel.setCoverColor('authorText', color)),
                  _ColorButton(label: 'Author Box Color', color: viewModel.authorBoxColor, onColorSelected: (color) => viewModel.setCoverColor('authorBox', color)),
                ],
              ),
              _TopOffsetSlider(
                label: 'Author Top Offset',
                value: viewModel.authorTopOffset,
                onChanged: viewModel.setAuthorTopOffset,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.subtitleController,
                      decoration: const InputDecoration(
                        labelText: 'Subtitle',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _ColorButton(label: 'Subtitle Text Color', color: viewModel.subtitleTextColor, onColorSelected: (color) => viewModel.setCoverColor('subtitleText', color)),
                  _ColorButton(label: 'Subtitle Box Color', color: viewModel.subtitleBoxColor, onColorSelected: (color) => viewModel.setCoverColor('subtitleBox', color)),
                ],
              ),
              _TopOffsetSlider(
                label: 'Subtitle Top Offset',
                value: viewModel.subtitleTopOffset,
                onChanged: viewModel.setSubtitleTopOffset,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.taglineController,
                      decoration: const InputDecoration(
                        labelText: 'Tagline',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _ColorButton(label: 'Tagline Text Color', color: viewModel.taglineTextColor, onColorSelected: (color) => viewModel.setCoverColor('taglineText', color)),
                  _ColorButton(label: 'Tagline Box Color', color: viewModel.taglineBoxColor, onColorSelected: (color) => viewModel.setCoverColor('taglineBox', color)),
                ],
              ),
              _TopOffsetSlider(
                label: 'Tagline Top Offset',
                value: viewModel.taglineTopOffset,
                onChanged: viewModel.setTaglineTopOffset,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.seriesTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Series Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _ColorButton(label: 'Series Title Text Color', color: viewModel.seriesTitleTextColor, onColorSelected: (color) => viewModel.setCoverColor('seriesTitleText', color)),
                  _ColorButton(label: 'Series Title Box Color', color: viewModel.seriesTitleBoxColor, onColorSelected: (color) => viewModel.setCoverColor('seriesTitleBox', color)),
                ],
              ),
              _TopOffsetSlider(
                label: 'Series Title Top Offset',
                value: viewModel.seriesTitleTopOffset,
                onChanged: viewModel.setSeriesTitleTopOffset,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.editionLineController,
                      decoration: const InputDecoration(
                        labelText: 'Edition Line',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _ColorButton(label: 'Edition Line Text Color', color: viewModel.editionLineTextColor, onColorSelected: (color) => viewModel.setCoverColor('editionLineText', color)),
                  _ColorButton(label: 'Edition Line Box Color', color: viewModel.editionLineBoxColor, onColorSelected: (color) => viewModel.setCoverColor('editionLineBox', color)),
                ],
              ),
              _TopOffsetSlider(
                label: 'Edition Line Top Offset',
                value: viewModel.editionLineTopOffset,
                onChanged: viewModel.setEditionLineTopOffset,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.cornerBadgeTextController,
                      decoration: const InputDecoration(
                        labelText: 'Corner Badge',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _ColorButton(label: 'Badge Text Color', color: viewModel.cornerBadgeTextColor, onColorSelected: (color) => viewModel.setCoverColor('cornerBadgeText', color)),
                  _ColorButton(label: 'Badge Color', color: viewModel.cornerBadgeColor, onColorSelected: (color) => viewModel.setCoverColor('cornerBadge', color)),
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
              Text(
                'Cover Layout',
                style: AppTextStyles.h3(context),
              ),

              SegmentedButton<CoverLayout>(
                showSelectedIcon: false, // cleaner look
                segments: const <ButtonSegment<CoverLayout>>[
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
                  ButtonSegment(
                    value: CoverLayout.bigCenterTitle,
                    icon: Icon(Icons.crop_7_5), // visually implies large center block
                    label: Text('Modern'),
                    tooltip: 'Big centered title layout',
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

              FilledButton(
                onPressed: canSubmit ? () {
                  // ensures errors are visible if something is off
                  if (_formKey.currentState!.validate()) {
                    viewModel.fetchCover();
                  }
                }  : null,
                child: Text(
                  'Generate Cover',
                  style: AppTextStyles.button(context),
                ),
              ),

              OutlinedButton(
                onPressed: () {
                  _formKey.currentState?.reset(); // clears validation messages
                  viewModel.clearFields();
                },
                child: Text(
                  'Clear Fields',
                  style: AppTextStyles.button(context),
                ),
              ),

              OutlinedButton(
                onPressed: (viewModel.cover != null && !viewModel.isBusy)
                    ? viewModel.saveCover
                    : null,
                child: Text('Save Cover', style: AppTextStyles.button(context)),
              ),
            ],
          ),
        ),
      ),
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
  });

  final String label;
  final Color color;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: IconButton(
        onPressed: () async {
          var selected = color;
          final confirmed = await ColorPicker(
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
          width: 22,
          height: 22,
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