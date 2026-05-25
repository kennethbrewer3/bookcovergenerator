import 'package:book_cover_designer_flutter/app/logging/logger.dart';
import 'package:book_cover_designer_flutter/screens/home/widgets/ebook_cover_image.dart';
import 'package:book_cover_designer_flutter/screens/home/widgets/ebook_info_form.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: ResizableWidget(
              isHorizontalSeparator: false, // optional
              isDisabledSmartHide: false, // optional
              separatorColor: Colors.blue, // optional
              separatorSize: 10, // optional
              percentages: const [0.5, 0.5], // optional
              onResized:
                  (infoList) => // optional
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
    await viewModel.loadCoverSizePresets();
    await viewModel.loadAuthors();
    await viewModel.fetchCover();
  }
}
