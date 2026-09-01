import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Branding Palette
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF03A9F4);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentAmber = Color(0xFFFFC107);
  static const Color accentGreen = Color(0xFF4CAF50);

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFF1F5F9);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF1E293B);

  // State Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Dynamic Weather Gradient Palettes
  static const List<Color> sunnyGradient = [
    Color(0xFF3B82F6),
    Color(0xFF60A5FA),
    Color(0xFFFDE047),
  ];

  static const List<Color> nightClearGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E1B4B),
    Color(0xFF312E81),
  ];

  static const List<Color> cloudyGradient = [
    Color(0xFF475569),
    Color(0xFF64748B),
    Color(0xFF94A3B8),
  ];

  static const List<Color> rainyGradient = [
    Color(0xFF1E293B),
    Color(0xFF334155),
    Color(0xFF2563EB),
  ];

  static const List<Color> thunderstormGradient = [
    Color(0xFF090D16),
    Color(0xFF1E1B4B),
    Color(0xFF4338CA),
  ];

  static const List<Color> snowyGradient = [
    Color(0xFF475569),
    Color(0xFF93C5FD),
    Color(0xFFE2E8F0),
  ];
}
