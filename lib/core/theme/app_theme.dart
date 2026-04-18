import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final heading = GoogleFonts.manrope();
    final body = GoogleFonts.plusJakartaSans();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      textTheme: TextTheme(
        headlineLarge: heading.copyWith(fontWeight: FontWeight.w800),
        headlineMedium: heading.copyWith(fontWeight: FontWeight.w700),
        titleLarge: heading.copyWith(fontWeight: FontWeight.w700),
        bodyLarge: body.copyWith(fontWeight: FontWeight.w500),
        bodyMedium: body.copyWith(fontWeight: FontWeight.w400),
        labelLarge: body.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderMedium),
        ),
      ),
    );
  }
}
