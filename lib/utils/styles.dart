import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

extension CustomTextStyle on TextTheme {
  TextStyle get formFieldHeading => GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w500, color: Get.theme.primaryColor);
  TextStyle get formFieldSmallHeading => GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w500, color: Get.theme.primaryColor);

  TextStyle get s14w600 =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600);
  TextStyle get s14w500 =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500);
  TextStyle get s18w500 =>
      GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500);
  TextStyle get s12w500 =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500);
  TextStyle get s12w400 =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400);
  TextStyle get s20w700 =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700);
  TextStyle get s16w600 =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);
}

extension CustomThemeData on ThemeData {
  MaterialColor get primarySwatch => const MaterialColor(0xFF101828, {
        // 25: Color(0xFF2196f3),
        50: Color(0xFFe3f2fd),
        100: Color(0xFFbbdefb),
        200: Color(0xFF90caf9),
        300: Color(0xFF64b5f6),
        400: Color(0xFF42a5f5),
        500: Color(0xFF2196f3),
        600: Color(0xFF1e88e5),
        700: Color(0xFF1976d2),
        800: Color(0xFF1565c0),
        900: Color(0xFF0d47a1)
      });
}
