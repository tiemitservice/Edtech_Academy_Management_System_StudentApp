import 'package:edtechschool/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle headerTitle = GoogleFonts.suwannaphum(
    color: AppColors.cardBackground,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle headerSubtitle = GoogleFonts.suwannaphum(
    color: AppColors.cardBackground.withAlpha(60),
    fontSize: 16,
  );

  static final TextStyle sectionTitle = GoogleFonts.suwannaphum(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.darkText,
  );

  static final TextStyle cardTitle = GoogleFonts.suwannaphum(
    color: AppColors.cardBackground,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static final TextStyle statValue = GoogleFonts.suwannaphum(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle statLabel = GoogleFonts.suwannaphum(
    fontSize: 14,
    color: AppColors.mediumText,
  );

  static final TextStyle buttonLabel = GoogleFonts.suwannaphum(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.cardBackground,
  );

  static final TextStyle drawerItem = GoogleFonts.suwannaphum(
    color: AppColors.darkText,
    fontWeight: FontWeight.w500,
  );
}
