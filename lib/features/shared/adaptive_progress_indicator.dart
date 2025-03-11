import 'package:home_staff/helpers/helper_extensions.dart';
import 'package:flutter/material.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  final Color? customColor;

  const AdaptiveProgressIndicator({
    super.key,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      backgroundColor: customColor ?? context.theme.primaryColor,
    );
  }
}
