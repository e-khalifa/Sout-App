import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
              colors: [
                Colors.yellow.shade300,
                Theme.of(context).primaryColor,
              ],
            ).createShader(Rect.fromLTWH(0, 10, bounds.width, bounds.height)),
        child: const Icon(Icons.graphic_eq));
  }
}
