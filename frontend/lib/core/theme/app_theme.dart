import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  // Color tokens used across newer + legacy UI files.
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF66BB6A);
  static const Color accent = Color(0xFFFFB300);
  static const Color accentYellow = Color(0xFFFBC02D);

   
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFC62828);

  static const Color surface = Colors.white;
  static const Color background = Color(0xFFF5F7F2);
  static const Color cardShadow = Color(0x1A000000);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);

  // Legacy aliases used in some screens/components.
  static const Color primaryColor = primary;
  static const Color secondaryColor = Color(0xFF1565C0);
  static const Color accentColor = accent;
  static const Color successColor = success;
  static const Color warningColor = warning;
  static const Color errorColor = error;

   
  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;
  static const double borderRadiusSmall = 8;
  static const double borderRadiusMedium = 12;

    
  static ThemeData get theme => lightTheme;

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        
        scaffoldBackgroundColor: background,
        textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
          bodyLarge: GoogleFonts.plusJakartaSans(color: textPrimary),
          bodyMedium: GoogleFonts.plusJakartaSans(color: textPrimary),
        ),
        
        appBarTheme: AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        cardTheme: CardThemeData(
          color: surface,
          elevation: 2,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      
    
      );

    
  static ThemeData get darkTheme => ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ),
      );
}