import 'dart:ui';
import 'package:flutter/material.dart';

class BottomRectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
// path.moveTo(size.width / 2 - 25, size.height / 2);
//     path.lineTo(size.width / 2 + 25, size.height / 2);
//     path.lineTo(size.width / 2 + 50, size.height / 2 + 25);
//     path.lineTo(size.width / 2 - 50, size.height / 2 + 25);
//     path.lineTo(size.width / 2 - 25, size.height / 2);
    path.lineTo(size.width / 2 - 70, 0);
    path.lineTo(size.width / 2 - 35, size.height / 10);
    path.lineTo(size.width / 2 + 35, size.height / 10);
    path.lineTo(size.width / 2 + 70, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
