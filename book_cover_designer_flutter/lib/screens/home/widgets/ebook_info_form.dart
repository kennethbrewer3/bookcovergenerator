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
