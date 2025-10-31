/// Premium Dark Theme Configuration
/// Material 3 design with premium dark aesthetics and glass-morphism effects

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_tokens.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData darkTheme() {
    final baseTextTheme = GoogleFonts.interTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.success,
        error: AppColors.danger,
        surface: AppColors.cardBackground,
        surfaceTint: AppColors.primaryAccent.withValues(alpha: 0.1),
      ),
      
      scaffoldBackgroundColor: AppColors.backgroundBase,
      dividerColor: AppColors.divider,
      
      // Status bar styling for glassmorphism
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      
      // Enhanced Card Theme for Glassmorphism
      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      
      // Primary Button with Gradient
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.primaryAccent.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(
            Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      
      // Outlined/Secondary Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return const Color(0xFF1A2430);
            }
            return Colors.transparent;
          }),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryAccent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      
      // Modern Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryAccent,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: baseTextTheme.labelSmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: baseTextTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Typography Scale
      textTheme: TextTheme(
        displayLarge: baseTextTheme.displayLarge?.merge(AppTypography.h1.copyWith(color: AppColors.textPrimary)),
        displayMedium: baseTextTheme.displayMedium?.merge(AppTypography.h2.copyWith(color: AppColors.textPrimary)),
        displaySmall: baseTextTheme.displaySmall?.merge(AppTypography.h3.copyWith(color: AppColors.textPrimary)),
        headlineLarge: baseTextTheme.headlineLarge?.merge(AppTypography.h1.copyWith(color: AppColors.textPrimary)),
        headlineMedium: baseTextTheme.headlineMedium?.merge(AppTypography.h2.copyWith(color: AppColors.textPrimary)),
        headlineSmall: baseTextTheme.headlineSmall?.merge(AppTypography.h3.copyWith(color: AppColors.textPrimary)),
        titleLarge: baseTextTheme.titleLarge?.merge(AppTypography.h3.copyWith(color: AppColors.textPrimary)),
        bodyLarge: baseTextTheme.bodyLarge?.merge(AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary)),
        bodyMedium: baseTextTheme.bodyMedium?.merge(AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
        bodySmall: baseTextTheme.bodySmall?.merge(AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        labelLarge: baseTextTheme.labelLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        labelMedium: baseTextTheme.labelMedium?.merge(AppTypography.caption.copyWith(color: AppColors.textSecondary)),
        labelSmall: baseTextTheme.labelSmall?.merge(AppTypography.caption.copyWith(color: AppColors.textSecondary)),
      ),
      
      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.danger, width: 1),
        ),
        labelStyle: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        hintStyle: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),
    );
  }
  
  static ThemeData lightTheme() {
    final baseTextTheme = GoogleFonts.interTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryAccent,
        secondary: AppColors.success,
        error: AppColors.danger,
        surface: Colors.white,
        surfaceTint: AppColors.primaryAccent.withValues(alpha: 0.05),
      ),
      
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      dividerColor: const Color(0xFFE5E7EB),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: const Color(0xFF1A1A1A),
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.primaryAccent.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: baseTextTheme.labelLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1A1A1A),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryAccent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryAccent,
        unselectedItemColor: const Color(0xFF6B7280),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: baseTextTheme.labelSmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: baseTextTheme.labelSmall?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      textTheme: TextTheme(
        displayLarge: baseTextTheme.displayLarge?.merge(
          AppTypography.h1.copyWith(color: const Color(0xFF1A1A1A)),
        ),
        displayMedium: baseTextTheme.displayMedium?.merge(
          AppTypography.h2.copyWith(color: const Color(0xFF1A1A1A)),
        ),
        displaySmall: baseTextTheme.displaySmall?.merge(
          AppTypography.h3.copyWith(color: const Color(0xFF1A1A1A)),
        ),
        headlineLarge: baseTextTheme.headlineLarge?.merge(
          AppTypography.h1.copyWith(color: const Color(0xFF1A1A1A)),
        ),
        headlineMedium: baseTextTheme.headlineMedium?.merge(
          AppTypography.h2.copyWith(color: const Color(0xFF1A1A1A)),
        ),
        headlineSmall: baseTextTheme.headlineSmall?.merge(
          AppTypography.h3.copyWith(color: const Color(0xFF1A1A1A)),
        ),
        titleLarge: baseTextTheme.titleLarge?.merge(
          AppTypography.h3.copyWith(color: const Color(0xFF1A1A1A)),
        ),
        bodyLarge: baseTextTheme.bodyLarge?.merge(
          AppTypography.bodyLarge.copyWith(color: const Color(0xFF1A1A1A)),
        ),
        bodyMedium: baseTextTheme.bodyMedium?.merge(
          AppTypography.bodyLarge.copyWith(color: const Color(0xFF6B7280)),
        ),
        bodySmall: baseTextTheme.bodySmall?.merge(
          AppTypography.bodySmall.copyWith(color: const Color(0xFF6B7280)),
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          color: const Color(0xFF1A1A1A),
          fontWeight: FontWeight.w600,
        ),
        labelMedium: baseTextTheme.labelMedium?.merge(
          AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
        ),
        labelSmall: baseTextTheme.labelSmall?.merge(
          AppTypography.caption.copyWith(color: const Color(0xFF6B7280)),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.danger, width: 1),
        ),
        labelStyle: baseTextTheme.bodyMedium?.copyWith(
          color: const Color(0xFF6B7280),
          fontSize: 14,
        ),
        hintStyle: baseTextTheme.bodyMedium?.copyWith(
          color: const Color(0xFF9CA3AF),
          fontSize: 14,
        ),
      ),
    );
  }
}
