import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..strokeWidth = 2.5
    ..style = PaintingStyle.stroke
    ..shader = applyTextBlueGradient();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      const Rect.fromLTWH(0, 0, 17, 17),
      _paint,
    );
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Shader applyTextBlueGradient() {
  return const LinearGradient(
    colors: [
      Color.fromRGBO(0, 53, 190, 1),
      Color.fromRGBO(57, 103, 224, 1),
      Color.fromRGBO(117, 154, 255, 1)
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0));
}