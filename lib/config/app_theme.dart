import 'package:flutter/material.dart';

class AppTheme {
  // --- Grab-inspired Brand Colors ---
  static const Color primaryColor = Color(0xFF00B14F); // Grab's signature vibrant Green
  static const Color accentColor = Color(0xFF8BC34A); // Lighter Green, for subtle accents
  static const Color highlightColor = Color(0xFFFFD700); // Golden Yellow, for warnings/promotions (similar to Grab's food/delivery elements)

  // --- Neutral Colors ---
  static const Color backgroundColor = Color(0xFFF8F8F8); // Very light grey, clean and modern background
  static const Color cardColor = Colors.white; // Pure white for cards, very common in Grab
  static const Color dividerColor = Color(0xFFE0E0E0); // Light Gray for dividers

  // --- Text Colors ---
  static const Color textColor = Color(0xFF333333); // Dark Gray for primary text, easy to read
  static const Color lightTextColor = Color(0xFF757575); // Medium Gray for secondary text, hints
  static const Color invertedTextColor = Colors.white; // White text on dark/colored backgrounds

  // --- Semantic Colors (for status messages) ---
  static const Color errorColor = Color(0xFFE74C3C); // Red for errors
  static const Color successColor = Color(0xFF00B14F); // Use primary green for success
  static const Color warningColor = Color(0xFFF39C12); // Orange for warnings

  // --- Main Theme Data ---
  static ThemeData lightTheme = ThemeData(
    // Global properties
    primaryColor: primaryColor,
    canvasColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    brightness: Brightness.light,
    fontFamily: 'Noto Sans Thai', // Keeping Noto Sans Thai as requested

    // --- AppBar Theme ---
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor, // Grab Green AppBar
      foregroundColor: invertedTextColor, // White icons and text
      elevation: 0, // Flat design
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Noto Sans Thai',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: invertedTextColor,
      ),
      iconTheme: IconThemeData(color: invertedTextColor), // White AppBar icons
    ),

    // --- ElevatedButton Theme ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // Main buttons are Grab Green
        foregroundColor: invertedTextColor, // White text on buttons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Slightly less rounded for a sleek look
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Taller buttons
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans Thai',
          fontSize: 18, // Slightly larger text
          fontWeight: FontWeight.bold,
        ),
        elevation: 2, // Subtle shadow for depth
      ),
    ),

    // --- OutlinedButton Theme ---
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor, // Green border and text
        side: const BorderSide(color: primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans Thai',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
    ),

    // --- TextButton Theme ---
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor, // Grab Green for text links/actions
        textStyle: const TextStyle(
          fontFamily: 'Noto Sans Thai',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // --- Input Decoration Theme (TextFields) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor, // White background for text fields
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none, // Default no border to look cleaner
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: dividerColor, width: 1), // Light grey border when enabled
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 2), // Green border when focused
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: const TextStyle(color: lightTextColor, fontFamily: 'Noto Sans Thai'),
      hintStyle: const TextStyle(color: lightTextColor, fontFamily: 'Noto Sans Thai'),
      errorStyle: const TextStyle(color: errorColor, fontFamily: 'Noto Sans Thai', fontSize: 12),
      prefixIconColor: lightTextColor,
      suffixIconColor: lightTextColor,
    ),

    // --- Card Theme ---
    cardTheme: CardThemeData(
      elevation: 2, // Subtle shadow for cards, gives a floating effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for cards
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      color: cardColor, // White card background
    ),

    // --- Divider Theme ---
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 20,
    ),

    // --- Text Theme (Extended) ---
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Noto Sans Thai'),
      displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Noto Sans Thai'),
      displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'Noto Sans Thai'),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: textColor, fontFamily: 'Noto Sans Thai'),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: textColor, fontFamily: 'Noto Sans Thai'),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textColor, fontFamily: 'Noto Sans Thai'),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColor, fontFamily: 'Noto Sans Thai'),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor, fontFamily: 'Noto Sans Thai'),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor, fontFamily: 'Noto Sans Thai'),
      bodyLarge: TextStyle(fontSize: 16, color: textColor, fontFamily: 'Noto Sans Thai'),
      bodyMedium: TextStyle(fontSize: 14, color: textColor, fontFamily: 'Noto Sans Thai'),
      bodySmall: TextStyle(fontSize: 12, color: lightTextColor, fontFamily: 'Noto Sans Thai'),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: invertedTextColor, fontFamily: 'Noto Sans Thai'), // Buttons
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: lightTextColor, fontFamily: 'Noto Sans Thai'),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: lightTextColor, fontFamily: 'Noto Sans Thai'),
    ).apply(
      displayColor: textColor,
      bodyColor: textColor,
    ),
  );
}