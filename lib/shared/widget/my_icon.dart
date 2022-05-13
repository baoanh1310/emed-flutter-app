import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// if both [iconData] and [svgIconPath] is set, the icon will be built based on [iconData]
class MyIcon extends StatelessWidget {
  final IconData iconData;
  final String svgIconPath;
  final Color color;
  final double size;

  MyIcon({
    this.iconData,
    this.svgIconPath,
    this.color,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (iconData != null) {
      return Icon(
        iconData,
        color: color,
        size: size,
      );
    }
    if (svgIconPath != null) {
      if (color != null)
        return SvgPicture.asset(
          svgIconPath,
          color: color,
          fit: BoxFit.none,
        );
      else
        return SvgPicture.asset(
          svgIconPath,
          fit: BoxFit.none,
        );
    }
    return Container();
  }
}
