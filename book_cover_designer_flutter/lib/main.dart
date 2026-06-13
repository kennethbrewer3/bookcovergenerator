import 'package:book_cover_designer_flutter/app/app.locator.dart';
import 'package:book_cover_designer_flutter/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(const EbookCoverGeneratorApp());
}

class EbookCoverGeneratorApp extends StatelessWidget {
  const EbookCoverGeneratorApp({super.key});

  static final _router = StackedRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Cover Designer',
      theme: ThemeData(primarySwatch: Colors.blue),
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
      ],
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: _router.onGenerateRoute,
      initialRoute: Routes.homeView,
    );
  }
}