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
  TextStyle get s12w500 =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500);
  TextStyle get s12w400 =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400);
  TextStyle get s20w700 =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700);
  TextStyle get s16w600 =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);
}
