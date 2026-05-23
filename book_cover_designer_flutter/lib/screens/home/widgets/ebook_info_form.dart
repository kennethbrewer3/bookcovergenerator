import 'package:book_cover_designer_flutter/screens/home/home_viewmodel.dart';
import 'package:book_cover_designer_flutter/services/generate_ebook_cover_service.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_text_styles.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_tokens.dart';
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

              TextFormField(
                controller: viewModel.ebookTitleController,
                decoration: const InputDecoration(
                  labelText: 'Ebook Title',
                  border: OutlineInputBorder(),
                ),
                validator: viewModel.validateEbookTitle,
                // onChanged not required now, controllers listeners handle it
              ),

              TextFormField(
                controller: viewModel.authorNameController,
                decoration: const InputDecoration(
                  labelText: 'Author Name',
                  border: OutlineInputBorder(),
                ),
                validator: viewModel.validateAuthorName,
              ),
              TextFormField(
                controller: viewModel.subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: viewModel.taglineController,
                decoration: const InputDecoration(
                  labelText: 'Tagline',
                  border: OutlineInputBorder(),
                ),
              ),
              _TopOffsetSlider(
                label: 'Tagline Top Offset',
                value: viewModel.taglineTopOffset,
                onChanged: viewModel.setTaglineTopOffset,
              ),
              TextFormField(
                controller: viewModel.seriesTitleController,
                decoration: const InputDecoration(
                  labelText: 'Series Title',
                  border: OutlineInputBorder(),
                ),
              ),
              _TopOffsetSlider(
                label: 'Series Title Top Offset',
                value: viewModel.seriesTitleTopOffset,
                onChanged: viewModel.setSeriesTitleTopOffset,
              ),
              TextFormField(
                controller: viewModel.editionLineController,
                decoration: const InputDecoration(
                  labelText: 'Edition Line',
                  border: OutlineInputBorder(),
                ),
              ),
              _TopOffsetSlider(
                label: 'Edition Line Top Offset',
                value: viewModel.editionLineTopOffset,
                onChanged: viewModel.setEditionLineTopOffset,
              ),
              TextFormField(
                controller: viewModel.cornerBadgeTextController,
                decoration: const InputDecoration(
                  labelText: 'Corner Badge',
                  border: OutlineInputBorder(),
                ),
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

              FilledButton(
                onPressed: canSubmit ? () {
                  // ensures errors are visible if something is off
                  if (_formKey.currentState!.validate()) {
                    viewModel.fetchCover();
                  }
                }  : null,
                child: Text(
                  'Generate Random Cover',
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
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('$label: ${(value * 100).round()}%'),
        Slider(
          value: value,
          min: -0.25,
          max: 0.25,
          divisions: 100,
          label: '${(value * 100).round()}%',
          onChanged: onChanged,
        ),
      ],
    );
  }
}
