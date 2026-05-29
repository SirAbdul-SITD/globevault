import 'package:flutter/material.dart';
import '../theme/gv_theme.dart';

class StarDisplay extends StatelessWidget {
  final int stars;
  final double size;
  const StarDisplay({super.key, required this.stars, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Icon(
          i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
          color: i < stars ? GVTheme.star : GVTheme.starEmpty,
          size: size,
        ),
      )),
    );
  }
}
