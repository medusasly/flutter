import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF0D1B2A);
  static const accent = Color(0xFFFF7A00);
  static const bg = Color(0xFFF6F7FB);

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: bg,
      primaryColor: primary,
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
