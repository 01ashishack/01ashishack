import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF6B35);
  static const Color secondary = Color(0xFFF7931E);
  static const Color background = Color(0xFFF5F6F7);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color lightOrange = Color(0xFFFFF3EE);
  static const Color textDark = Color(0xFF1A1A2A);
  static const Color textMedium = Color(0xFF374151);
  static const Color textGray = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderMedium = Color(0xFFE8E8E8);
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color info = Color(0xFF3B82F6);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
  );
}
