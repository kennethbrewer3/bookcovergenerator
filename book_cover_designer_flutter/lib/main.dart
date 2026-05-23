import 'package:book_cover_designer_client/book_cover_designer_client.dart';
import 'package:book_cover_designer_flutter/app/app.locator.dart';
import 'package:book_cover_designer_flutter/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:stacked_services/stacked_services.dart';

late final Client client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  final serverUrl = await getServerUrl();

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  await client.auth.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _router = StackedRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Cover Designer',
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: _router.onGenerateRoute,
      initialRoute: Routes.homeView,
    );
  }
}