// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:book_cover_designer_flutter/screens/greetings_screen.dart'
    as _i3;
import 'package:book_cover_designer_flutter/screens/home/home_view.dart' as _i2;
import 'package:book_cover_designer_flutter/screens/sign_in_screen.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i7;

class Routes {
  static const homeView = '/';

  static const greetingsScreen = '/greetings-screen';

  static const signInScreen = '/sign-in-screen';

  static const all = <String>{
    homeView,
    greetingsScreen,
    signInScreen,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.greetingsScreen,
      page: _i3.GreetingsScreen,
    ),
    _i1.RouteDef(
      Routes.signInScreen,
      page: _i4.SignInScreen,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.HomeView(key: args.key),
        settings: data,
      );
    },
    _i3.GreetingsScreen: (data) {
      final args = data.getArgs<GreetingsScreenArguments>(
        orElse: () => const GreetingsScreenArguments(),
      );
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i3.GreetingsScreen(key: args.key, onSignOut: args.onSignOut),
        settings: data,
      );
    },
    _i4.SignInScreen: (data) {
      final args = data.getArgs<SignInScreenArguments>(nullOk: false);
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i4.SignInScreen(key: args.key, child: args.child),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class HomeViewArguments {
  const HomeViewArguments({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class GreetingsScreenArguments {
  const GreetingsScreenArguments({
    this.key,
    this.onSignOut,
  });

  final _i5.Key? key;

  final _i6.Future<void> Function()? onSignOut;

  @override
  String toString() {
    return '{"key": "$key", "onSignOut": "$onSignOut"}';
  }

  @override
  bool operator ==(covariant GreetingsScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.onSignOut == onSignOut;
  }

  @override
  int get hashCode {
    return key.hashCode ^ onSignOut.hashCode;
  }
}

class SignInScreenArguments {
  const SignInScreenArguments({
    this.key,
    required this.child,
  });

  final _i5.Key? key;

  final _i5.Widget child;

  @override
  String toString() {
    return '{"key": "$key", "child": "$child"}';
  }

  @override
  bool operator ==(covariant SignInScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.child == child;
  }

  @override
  int get hashCode {
    return key.hashCode ^ child.hashCode;
  }
}

extension NavigatorStateExtension on _i7.NavigationService {
  Future<dynamic> navigateToHomeView({
    _i5.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToGreetingsScreen({
    _i5.Key? key,
    _i6.Future<void> Function()? onSignOut,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.greetingsScreen,
        arguments: GreetingsScreenArguments(key: key, onSignOut: onSignOut),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignInScreen({
    _i5.Key? key,
    required _i5.Widget child,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.signInScreen,
        arguments: SignInScreenArguments(key: key, child: child),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView({
    _i5.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithGreetingsScreen({
    _i5.Key? key,
    _i6.Future<void> Function()? onSignOut,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.greetingsScreen,
        arguments: GreetingsScreenArguments(key: key, onSignOut: onSignOut),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSignInScreen({
    _i5.Key? key,
    required _i5.Widget child,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.signInScreen,
        arguments: SignInScreenArguments(key: key, child: child),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
