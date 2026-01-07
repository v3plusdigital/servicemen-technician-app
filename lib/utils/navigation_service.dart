import 'package:flutter/material.dart';
import '../utils/app_routes.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static void logoutToLogin() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
          (route) => false,
    );
  }
}
