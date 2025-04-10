import 'package:flutter/material.dart';
import 'package:home_staff/theme/colors/app_colors.dart';

final lightAppColors = LightAppColors();

class LightAppColors extends AppColors {
  @override
  Color get primary100 => const Color(0xFF5BA65B); // green main
  @override
  Color get primary200 => const Color(0xFF6BBF6B);
  @override
  Color get primary300 => const Color(0xFF7CD67C);
  @override
  Color get primary400 => const Color(0xFF8EEB8E);
  @override
  Color get primary500 => const Color(0xFFA4F7A4);
  @override
  Color get primary600 => const Color(0xFFBBFABB);
  @override
  Color get primaryDark => const Color(0xFF2E5F30); // darker green

  @override
  Color get backgroundColor => const Color(0xFFF6F9F6); // light background
  @override
  Color get error => const Color(0xFFB00020);
}
