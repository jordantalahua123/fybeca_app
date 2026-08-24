import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Ícono de Microsoft: las 4 casillas de color oficiales de su logo.
class MicrosoftLogo extends StatelessWidget {
  final double size;

  const MicrosoftLogo({super.key, this.size = 20});

  static const _red = Color(0xFFF25022);
  static const _green = Color(0xFF7FBA00);
  static const _blue = Color(0xFF00A4EF);
  static const _yellow = Color(0xFFFFB900);

  @override
  Widget build(BuildContext context) {
    final cell = (size - 2) / 2;
    Widget square(Color color) => Container(width: cell, height: cell, color: color);

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [square(_red), square(_green)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [square(_blue), square(_yellow)],
          ),
        ],
      ),
    );
  }
}

/// Ícono de Google: aproximación del logo "G" con sus 4 colores oficiales.
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  static const _blue = Color(0xFF4285F4);
  static const _green = Color(0xFF34A853);
  static const _yellow = Color(0xFFFBBC05);
  static const _red = Color(0xFFEA4335);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.42;
    final rect = Rect.fromCircle(radius: radius - strokeWidth / 2, center: center);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Cuatro arcos de 90° con los colores oficiales de Google.
    canvas.drawArc(rect, _deg(-45), _deg(90), false, paint..color = _red);
    canvas.drawArc(rect, _deg(45), _deg(90), false, paint..color = _green);
    canvas.drawArc(rect, _deg(135), _deg(90), false, paint..color = _yellow);
    canvas.drawArc(rect, _deg(225), _deg(90), false, paint..color = _blue);

    // Barra horizontal azul característica de la "G".
    final barPaint = Paint()..color = _blue;
    canvas.drawRect(
      Rect.fromLTWH(center.dx, center.dy - strokeWidth / 2, radius - strokeWidth * 0.15, strokeWidth),
      barPaint,
    );
  }

  double _deg(double degrees) => degrees * math.pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
