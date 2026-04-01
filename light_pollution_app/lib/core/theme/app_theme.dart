import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_fonts.dart';

class AppColors {
  // Brand colors from brand guideline
  static const navy = Color(0xFF133354);
  static const white = Color(0xFFFFFFFF);
  static const dark = Color(0xFF0E1720);

  // Light theme colors
  static const background = white;
  static const cardBg = Color(0xFFF5F5F5);
  static const divider = Color(0xFFE8E8E8);
  static const textPrimary = dark;
  static const textSecondary = Color(0xFF6B7280);
  static const textHint = Color(0xFF9CA3AF);

  // Dark theme colors
  static const darkBackground = Color(0xFF0E1720);
  static const darkSurface = Color(0xFF1A2633);
  static const darkCardBg = Color(0xFF1E2D3D);
  static const darkDivider = Color(0xFF2A3A4A);
  static const darkTextPrimary = Color(0xFFE8ECF0);
  static const darkTextSecondary = Color(0xFF8899AA);
  static const darkTextHint = Color(0xFF5A6A7A);
  static const navyLight = Color(0xFF4A8CCF);
}

/// Theme-aware color accessor. Usage: `context.colors.surface`
class AdaptiveColors {
  final bool isDark;
  const AdaptiveColors(this.isDark);

  Color get surface => isDark ? AppColors.darkSurface : AppColors.white;
  Color get background => isDark ? AppColors.darkBackground : AppColors.white;
  Color get card => isDark ? AppColors.darkCardBg : AppColors.cardBg;
  Color get divider => isDark ? AppColors.darkDivider : AppColors.divider;
  Color get textPrimary => isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get textSecondary => isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get textHint => isDark ? AppColors.darkTextHint : AppColors.textHint;
  Color get accent => isDark ? AppColors.navyLight : AppColors.navy;
}

extension AdaptiveColorsX on BuildContext {
  AdaptiveColors get colors =>
      AdaptiveColors(Theme.of(this).brightness == Brightness.dark);
}

class AppTheme {
  static ThemeData lightTheme(Locale locale) {
    final textTheme = AppFonts.textTheme(locale);
    final isArabic = locale.languageCode == 'ar';
    final fontFn = isArabic ? GoogleFonts.notoSansArabic : GoogleFonts.montserrat;

    return ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: AppColors.navy,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: fontFn(
          color: AppColors.navy,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.navy),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        height: 64,
        elevation: 0,
        indicatorColor: AppColors.navy.withValues(alpha: 0.1),
        labelTextStyle: WidgetStatePropertyAll(
          fontFn(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        iconTheme: const WidgetStatePropertyAll(
          IconThemeData(color: AppColors.textSecondary, size: 24),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: fontFn(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.navy),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.navy.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.navy.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
        ),
        labelStyle: fontFn(color: AppColors.textSecondary),
        hintStyle: fontFn(color: AppColors.textHint),
      ),
    );
  }

  static ThemeData darkTheme(Locale locale) {
    final textTheme = AppFonts.textTheme(locale);
    final isArabic = locale.languageCode == 'ar';
    final fontFn = isArabic ? GoogleFonts.notoSansArabic : GoogleFonts.montserrat;

    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: AppColors.navy,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: AppColors.darkCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: fontFn(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.navyLight),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        height: 64,
        elevation: 0,
        indicatorColor: AppColors.navyLight.withValues(alpha: 0.15),
        labelTextStyle: WidgetStatePropertyAll(
          fontFn(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextSecondary,
          ),
        ),
        iconTheme: const WidgetStatePropertyAll(
          IconThemeData(color: AppColors.darkTextSecondary, size: 24),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navyLight,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: fontFn(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navyLight,
          side: const BorderSide(color: AppColors.navyLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 0.5,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.navyLight.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.navyLight.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.navyLight, width: 1.5),
        ),
        labelStyle: fontFn(color: AppColors.darkTextSecondary),
        hintStyle: fontFn(color: AppColors.darkTextHint),
      ),
    );
  }
}
