import 'package:flutter/material.dart';
import '../utils/assets_path.dart';

class AppLogoWidget extends StatelessWidget {
  final double size;

  const AppLogoWidget({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsPath.logo,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(size / 4),
        ),
        alignment: Alignment.center,
        child: Text(
          'S',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
