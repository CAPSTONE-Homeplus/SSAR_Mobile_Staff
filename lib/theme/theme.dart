import 'package:flutter/material.dart';
import 'package:home_staff/gen/fonts.gen.dart';

final appTheme = AppTheme();

class AppTheme {
  final _seedColor = const Color(0xFF4CC9F0);

  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: FontFamily.manrope,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        fontFamily: FontFamily.manrope,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
}
