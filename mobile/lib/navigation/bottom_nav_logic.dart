import 'package:flutter/material.dart';
import '../views/dashboard_screen.dart';
import '../views/map_screen.dart';

class BottomNavLogic {
  static void handleTap(
    BuildContext context, {
    required int currentIndex,
    required int newIndex,
    required List<Map<String, dynamic>> trips,
  }) {
    if (newIndex == currentIndex) return;

    switch (newIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MapScreen(trips: trips),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/alerts');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/lookups');
        break;
    }
  }
}
