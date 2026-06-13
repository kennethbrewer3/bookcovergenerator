import 'package:book_cover_designer_flutter/app/logging/logger.dart';
import 'package:book_cover_designer_flutter/main.dart';
import 'package:book_cover_designer_flutter/screens/home/widgets/ebook_cover_image.dart';
import 'package:book_cover_designer_flutter/screens/home/widgets/ebook_info_form.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  final log = getLogger('HomeView');
  HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Cover Designer'),
        actions: [
          ValueListenableBuilder<AppThemeVariant>(
            valueListenable: themeService.variant,
            builder: (context, current, _) {
              return PopupMenuButton<AppThemeVariant>(
                tooltip: 'Select theme',
                icon: const Icon(Icons.palette_outlined),
                onSelected: (v) => themeService.setVariant(v),
                itemBuilder: (_) => AppThemeVariant.values
                    .map(
                      (v) => PopupMenuItem(
                        value: v,
                        child: Row(
                          children: [
                            Icon(
                              v == current
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(v.label),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: ResizableWidget(
              isHorizontalSeparator: false,
              isDisabledSmartHide: false,
              separatorColor: Colors.blue,
              separatorSize: 10,
              percentages: const [0.5, 0.5],
              onResized:
                  (infoList) =>
                  log.d(
                    infoList
                        .map((x) => '(${x.size}, ${x.percentage}%)')
                        .join(", "),
                  ),
              children: [
                EbookInfoForm(),
                const EbookCoverImage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) async {
    await viewModel.fetchCover();
  }
}
