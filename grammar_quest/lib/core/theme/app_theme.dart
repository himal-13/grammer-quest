import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Light Mode
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF4A90E2);
  static const Color lightSecondary = Color(0xFF6C757D);
  static const Color lightAccent = Color(0xFFF39C12);
  static const Color lightText = Color(0xFF2D3436);
  static const Color lightSuccess = Color(0xFF2ECC71);
  static const Color lightError = Color(0xFFE74C3C);

  // Colors - Dark Mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFFBB86FC);
  static const Color darkSecondary = Color(0xFF03DAC6);
  static const Color darkAccent = Color(0xFFCF6679);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkSuccess = Color(0xFF81C784);
  static const Color darkError = Color(0xFFE57373);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightBackground,
      cardColor: lightSurface,
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: lightText,
        displayColor: lightText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: lightText),
        titleTextStyle: TextStyle(color: lightText, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        surface: lightSurface,
        onSurface: lightText,
        error: lightError,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkSurface,
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: darkText,
        displayColor: darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: darkText),
        titleTextStyle: TextStyle(color: darkText, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        surface: darkSurface,
        onSurface: darkText,
        error: darkError,
      ),
    );
  }
}
