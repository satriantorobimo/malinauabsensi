import 'package:flutter/material.dart';

class FaceOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(351, 261),
      painter: FaceOverlayPainter(),
    );
  }
}

class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final clearPaint = Paint()..blendMode = BlendMode.clear;

    final outlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw dark overlay
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), darkPaint);

    // Calculate face oval
    final ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.65,
      height: size.height * 0.85,
    );

    // Clear face oval area
    canvas.drawOval(ovalRect, clearPaint);

    // Draw face outline
    canvas.drawOval(ovalRect, outlinePaint);

    // Draw horizontal line
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.62),
      Offset(size.width * 0.8, size.height * 0.62),
      outlinePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
