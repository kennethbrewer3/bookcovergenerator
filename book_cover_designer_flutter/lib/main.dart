import 'package:book_cover_designer_flutter/app/app.locator.dart';
import 'package:book_cover_designer_flutter/app/app.router.dart';
import 'package:book_cover_designer_flutter/app/app_services.dart';
import 'package:book_cover_designer_flutter/l10n/app_localizations.dart';
import 'package:book_cover_designer_flutter/services/custom_font_service.dart';
import 'package:book_cover_designer_flutter/services/cover_font_registry.dart';
import 'package:book_cover_designer_flutter/services/locale_service.dart';
import 'package:book_cover_designer_flutter/services/theme_service.dart';
import 'package:book_cover_designer_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  GoogleFonts.config.allowRuntimeFetching = false;

  await setupLocator();
  await CoverFontRegistry.registerBuiltInFonts();
  themeService = await ThemeService.create();
  localeService = await LocaleService.create();
  customFontService = await CustomFontService.create();

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
              debugShowCheckedModeBanner: false,
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