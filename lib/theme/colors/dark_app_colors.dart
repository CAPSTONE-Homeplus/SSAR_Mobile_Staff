import 'package:flutter/material.dart';
import 'package:home_staff/theme/colors/app_colors.dart';

final darkAppColors = DarkAppColors();

class DarkAppColors extends AppColors {
  @override
  Color get primary100 => const Color(0xFF336633);
  @override
  Color get primary200 => const Color(0xFF3E7A3E);
  @override
  Color get primary300 => const Color(0xFF479147);
  @override
  Color get primary400 => const Color(0xFF5AA85A);
  @override
  Color get primary500 => const Color(0xFF6BBF6B);
  @override
  Color get primary600 => const Color(0xFF84D984);
  @override
  Color get primaryDark => const Color(0xFF1C3B1D); // very dark green

  @override
  Color get backgroundColor => const Color(0xFF121212); // dark background
  @override
  Color get error => const Color(0xFFCF6679); // material red
}
