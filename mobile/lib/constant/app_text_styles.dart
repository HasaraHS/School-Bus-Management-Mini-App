import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: AppDimensions.fontSizeDisplay,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary
  );

  static const TextStyle title = TextStyle(
    fontSize: AppDimensions.fontSizeTitle,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: AppDimensions.fontSizeMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: AppDimensions.fontSizeSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: AppDimensions.fontSizeLarge,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle label = TextStyle(
    fontSize: AppDimensions.fontSizeSmall,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}