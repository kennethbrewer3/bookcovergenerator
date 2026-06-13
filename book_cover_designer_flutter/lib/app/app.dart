import 'package:book_cover_designer_flutter/screens/home/home_view.dart';
import 'package:book_cover_designer_flutter/screens/settings/settings_view.dart';
import 'package:book_cover_designer_flutter/services/generate_ebook_cover_service.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView, initial: true),
    MaterialRoute(page: SettingsView),
  ],
  dependencies: [
    LazySingleton(classType: GenerateEbookCoverService),
  ],
)
class App {}