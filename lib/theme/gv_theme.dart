import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GVTheme {
  // Core palette — dark vault explorer
  static const Color bg = Color(0xFF0B0D1A);
  static const Color surface = Color(0xFF141729);
  static const Color card = Color(0xFF1C2035);
  static const Color border = Color(0xFF2A2F4A);
  static const Color gold = Color(0xFFC8A96E);
  static const Color goldLight = Color(0xFFE8C98E);
  static const Color teal = Color(0xFF3DD9C5);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color textPrimary = Color(0xFFF0F2FF);
  static const Color textSecondary = Color(0xFF8890B0);
  static const Color star = Color(0xFFFFD700);
  static const Color starEmpty = Color(0xFF3A3F5C);

  static TextTheme _textTheme() => TextTheme(
        displayLarge: GoogleFonts.cinzel(
            fontSize: 36, fontWeight: FontWeight.w700, color: textPrimary, letterSpacing: 2),
        displayMedium: GoogleFonts.cinzel(
            fontSize: 26, fontWeight: FontWeight.w600, color: textPrimary, letterSpacing: 1.5),
        headlineMedium: GoogleFonts.cinzel(
            fontSize: 20, fontWeight: FontWeight.w600, color: gold, letterSpacing: 1),
        titleLarge: GoogleFonts.outfit(
            fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        titleMedium: GoogleFonts.outfit(
            fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
        bodyLarge: GoogleFonts.outfit(
            fontSize: 16, fontWeight: FontWeight.w400, color: textPrimary),
        bodyMedium: GoogleFonts.outfit(
            fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: GoogleFonts.outfit(
            fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary, letterSpacing: 0.5),
      );

  static ThemeData build() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: gold,
          secondary: teal,
          surface: surface,
          error: coral,
        ),
        textTheme: _textTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: bg,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.cinzel(
            fontSize: 18, fontWeight: FontWeight.w700, color: gold, letterSpacing: 1.5),
          iconTheme: const IconThemeData(color: gold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: bg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: gold, width: 1.5),
          ),
          hintStyle: GoogleFonts.outfit(color: textSecondary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        useMaterial3: true,
      );
}
