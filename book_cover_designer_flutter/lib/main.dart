import 'package:book_cover_designer_flutter/app/app.locator.dart';
import 'package:book_cover_designer_flutter/app/app.router.dart';
import 'package:book_cover_designer_flutter/l10n/app_localizations.dart';
import 'package:book_cover_designer_flutter/services/locale_service.dart';
import 'package:book_cover_designer_flutter/services/theme_service.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:stacked_services/stacked_services.dart';

late final ThemeService themeService;
late final LocaleService localeService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  themeService = await ThemeService.create();
  localeService = await LocaleService.create();

  runApp(EbookCoverGeneratorApp(
    themeService: themeService,
    localeService: localeService,
  ));
}

class EbookCoverGeneratorApp extends StatelessWidget {
  const EbookCoverGeneratorApp({
    super.key,
    required this.themeService,
    required this.localeService,
  });

  final ThemeService themeService;
  final LocaleService localeService;
  static final _router = StackedRouter();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeVariant>(
      valueListenable: themeService.variant,
      builder: (context, variant, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: localeService.locale,
          builder: (context, locale, _) {
            return MaterialApp(
              title: 'Book Cover Designer',
              theme: AppTheme.forVariant(variant),
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                FlutterQuillLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              navigatorKey: StackedService.navigatorKey,
              onGenerateRoute: _router.onGenerateRoute,
              initialRoute: Routes.homeView,
            );
          },
        );
      },
    );
  }
}