import 'package:flutter/material.dart';

extension MediaQueryStateless on StatelessWidget {
  bool isAccessibilityOn(BuildContext context) {
    return MediaQuery.accessibleNavigationOf(context);
  }
}

extension MediaQueryStateful on StatefulWidget {
  bool isAccessibilityOn(BuildContext context) {
    return MediaQuery.accessibleNavigationOf(context);
  }
}

extension MediaQueryState on State {
  bool isAccessibilityOn() {
    return MediaQuery.accessibleNavigationOf(context);
  }
}