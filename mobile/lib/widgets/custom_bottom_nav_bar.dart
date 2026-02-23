import 'package:flutter/material.dart';
import '../constant/app_colors.dart';
import '../constant/app_dimensions.dart';
import '../constant/app_string.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: AppColors.surface,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppString.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: AppString.liveMap,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: AppString.alerts,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: AppString.lookups,
        ),
      ],
    );
  }
}