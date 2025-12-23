import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KamKajLogo extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;

  // Optional color to override the SVG's internal colors.
  // Useful for creating a monochrome version (e.g., all white or all black).
  // If null, the SVG's original colors are used.
  final Color? color;

  const KamKajLogo({
    super.key,
    this.width = 150,
    this.height = 150,
    this.fit = BoxFit.contain,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // The asset path logic is encapsulated here.
    const String assetName = 'assets/images/kamkaj_logo.svg';

    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      // Apply color filter if a specific color is provided
      colorFilter: color != null 
          ? ColorFilter.mode(color!, BlendMode.srcIn) 
          : null,
      semanticsLabel: 'KamKaj Logo',
    );
  }
}
