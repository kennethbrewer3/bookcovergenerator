import 'package:book_cover_designer_flutter/app/app.locator.dart';
import 'package:book_cover_designer_flutter/app/app.router.dart';
import 'package:book_cover_designer_flutter/services/theme_service.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:stacked_services/stacked_services.dart';

late final ThemeService themeService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  themeService = await ThemeService.create();

  runApp(EbookCoverGeneratorApp(themeService: themeService));
}

class EbookCoverGeneratorApp extends StatelessWidget {
  const EbookCoverGeneratorApp({super.key, required this.themeService});

  final ThemeService themeService;
  static final _router = StackedRouter();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeVariant>(
      valueListenable: themeService.variant,
      builder: (context, variant, _) {
        return MaterialApp(
          title: 'Book Cover Designer',
          theme: AppTheme.forVariant(variant),
          localizationsDelegates: const [
            FlutterQuillLocalizations.delegate,
          ],
          navigatorKey: StackedService.navigatorKey,
          onGenerateRoute: _router.onGenerateRoute,
          initialRoute: Routes.homeView,
        );
      },
    );
  }
}