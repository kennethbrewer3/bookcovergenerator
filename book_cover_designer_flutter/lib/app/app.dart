import 'package:book_cover_designer_flutter/screens/greetings_screen.dart';
import 'package:book_cover_designer_flutter/screens/home/home_view.dart';
import 'package:book_cover_designer_flutter/screens/sign_in_screen.dart';
import 'package:book_cover_designer_flutter/services/generate_ebook_cover_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView, initial: true),
    MaterialRoute(page: GreetingsScreen),
    MaterialRoute(page: SignInScreen),
  ],
  dependencies: [
    LazySingleton(classType: GenerateEbookCoverService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
  ],
)
class App {}