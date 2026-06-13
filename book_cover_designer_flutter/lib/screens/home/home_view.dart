import 'package:book_cover_designer_flutter/app/app.router.dart';
import 'package:book_cover_designer_flutter/app/logging/logger.dart';
import 'package:book_cover_designer_flutter/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTooltip,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).pushNamed(Routes.settingsView),
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
