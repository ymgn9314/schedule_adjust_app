import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget customIcon(String assetName, Color? color, double size) {
  return SvgPicture.asset(assetName, color: color, width: size, height: size);
}
