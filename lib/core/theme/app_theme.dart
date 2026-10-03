import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Pastel lavender theme inspired by the reference UI.
  static const Color _lavender = Color(0xFF6F6D8F);
  static const Color _lavenderDark = Color(0xFF5F5D7E);
  static const Color _rose = Color(0xFFF2A8C5);
  static const Color _cream = Color(0xFFF6F3EE);
  static const Color _ink = Color(0xFF2C2B3C);

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _lavender,
          brightness: Brightness.light,
        ).copyWith(
          primary: _lavender,
          secondary: _rose,
          surface: _cream,
          background: _cream,
        );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: _cream,
      textTheme: GoogleFonts.manropeTextTheme(
        base.textTheme,
      ).apply(bodyColor: _ink, displayColor: _ink),
      appBarTheme: AppBarTheme(
        backgroundColor: _cream,
        foregroundColor: _ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: _cream,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _ink,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: _lavender.withOpacity(0.12),
        labelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w600),
        secondaryLabelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _cream,
        selectedItemColor: _lavenderDark,
        unselectedItemColor: _lavender.withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
