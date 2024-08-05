import 'package:flutter/material.dart';
import 'package:sout_app/utlis/color_utility.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
              colors: [
                Colors.yellow.shade300,
                ColorUtility.main,
              ],
            ).createShader(Rect.fromLTWH(0, 10, bounds.width, bounds.height)),
        child: const Icon(Icons.graphic_eq));
  }
}
