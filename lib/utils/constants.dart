import 'package:flutter/material.dart';

// 颜色常量
class AppColors {
  static const Color primary = Color(0xFFEC7BA8); // 粉色
  static const Color primaryLight = Color(0xFFFFC0D9);
  static const Color primaryDark = Color(0xFFE85A8F);
  static const Color background = Color(0xFFFAF9F8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF999999);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyLighter = Color(0xFFFAFAFA);
  static const Color divider = Color(0xFFE8E8E8);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color border = Color(0xFFE8E8E8);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFF9800);
}

// 文本样式常量
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
  );
}

// 间距常量
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

// 圆角常量
class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double full = 999.0;
  static const double circle = 999.0;
}

// 阴影常量
class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const BoxShadow sm = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  );

  static const BoxShadow md = BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const BoxShadow lg = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

  static const BoxShadow xl = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );
}
