import 'package:flutter/material.dart';
import '../utils/assets_path.dart';

class AppLogoWidgetWhite extends StatelessWidget {
  final double size;

  const AppLogoWidgetWhite({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsPath.logo2,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(size / 3),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.spa_rounded, color: Colors.white, size: size / 2),
      ),
    );
  }
}
