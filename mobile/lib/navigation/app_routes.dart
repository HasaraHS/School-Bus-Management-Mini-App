import 'package:flutter/material.dart';
import '../views/dashboard_screen.dart';
import '../views/login_screen.dart';
import '../views/splash_screen.dart';
import '../views/map_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String liveMap = '/liveMap';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        dashboard: (context) => const DashboardScreen(),
        liveMap: (context) => MapScreen(trips: []),
      };
}