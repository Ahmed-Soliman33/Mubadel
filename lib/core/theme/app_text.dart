import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

TextStyle _cairo(double size, FontWeight w, Color c, {double? height}) =>
    GoogleFonts.cairo(fontSize: size, fontWeight: w, color: c, height: height);

class AppText {
  const AppText._();

  static TextStyle get pageTitle =>
      _cairo(24, FontWeight.w700, AppColors.ink, height: 1.3);
  static TextStyle get pageSubtitle =>
      _cairo(13, FontWeight.w400, AppColors.textMuted);
  static TextStyle get sectionTitle =>
      _cairo(18, FontWeight.w700, AppColors.ink);
  static TextStyle get cardTitle => _cairo(15, FontWeight.w700, AppColors.ink);
  static TextStyle get body => _cairo(14, FontWeight.w400, AppColors.ink);
  static TextStyle get bodyMuted =>
      _cairo(14, FontWeight.w400, AppColors.textMuted);
  static TextStyle get label => _cairo(13, FontWeight.w600, AppColors.ink);
  static TextStyle get price =>
      _cairo(18, FontWeight.w700, AppColors.forestGreen);
  static TextStyle get priceLarge =>
      _cairo(22, FontWeight.w700, AppColors.forestGreen);
  static TextStyle get caption =>
      _cairo(12, FontWeight.w600, AppColors.ink);
  static TextStyle get captionMuted =>
      _cairo(12, FontWeight.w400, AppColors.textMuted);
  static TextStyle get button => _cairo(16, FontWeight.w700, Colors.white);
}
