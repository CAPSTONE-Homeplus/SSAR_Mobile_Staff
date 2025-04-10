import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:home_staff/gen/assets.gen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) GoRouter.of(context).go('/login');
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                  turns: _rotationController,
                  child: SvgPicture.asset(
                    Assets.icons.hourglassTop,
                    width: 80,
                    height: 80,
                    colorFilter: const ColorFilter.mode(
                      Colors.black87,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  color: theme.primaryColor,
                  minHeight: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
