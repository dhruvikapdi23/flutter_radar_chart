import 'dart:math';

import 'package:flutter/material.dart';

class CustomChart extends CustomPainter {
  final int maxValue = 6;
  final double dotRadius = 5;

  // Example data per level
  final Map<String, List<int>> layerColors = {
    "green": [
      15, // full fill
      7, // D B
      5, // D B
      4,
      0, 0,
    ],
    "blue": [
      0, //
      8, // B
      2, // D B
      1, // D B C
      4, 0, // A
    ],
    "white": [
      1, //
      8, // B
      9, // D B
      11, // D B C
      11, 15, // A
    ],
  };

  final List<String> axisLabels = ["", "A", "B", "C", "D", "F", ""];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final step = size.width / 12;
    final Paint borderPaint =
        Paint()
          ..color = Colors.grey.withValues(alpha: .20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    final Paint dotPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.fill;

    // Draw concentric diamonds
    for (int i = 1; i <= maxValue; i++) {
      final offset = step * i;
      final path =
          Path()
            ..moveTo(center.dx, center.dy - offset)
            ..lineTo(center.dx + offset, center.dy)
            ..lineTo(center.dx, center.dy + offset)
            ..lineTo(center.dx - offset, center.dy)
            ..close();

      canvas.drawPath(path, borderPaint);
    }

    // Draw individual colored stripes per side per level
    for (int level = 1; level <= maxValue; level++) {
      final currentRadius = step * level;
      final prevRadius = step * (level - 1);

      for (int i = 0; i < 4; i++) {
        final angle1 = pi / 2 * i;
        final angle2 = pi / 2 * ((i + 1) % 4);

        final outer1 = Offset(
          center.dx + cos(angle1) * currentRadius,
          center.dy + sin(angle1) * currentRadius,
        );
        final outer2 = Offset(
          center.dx + cos(angle2) * currentRadius,
          center.dy + sin(angle2) * currentRadius,
        );
        final inner1 = Offset(
          center.dx + cos(angle1) * prevRadius,
          center.dy + sin(angle1) * prevRadius,
        );
        final inner2 = Offset(
          center.dx + cos(angle2) * prevRadius,
          center.dy + sin(angle2) * prevRadius,
        );

        final path =
            Path()
              ..moveTo(inner1.dx, inner1.dy)
              ..lineTo(outer1.dx, outer1.dy)
              ..lineTo(outer2.dx, outer2.dy)
              ..lineTo(inner2.dx, inner2.dy)
              ..close();

        if ((layerColors["green"]![level - 1] & (1 << i)) != 0) {
          canvas.drawPath(
            path,
            Paint()
              ..color = Colors.green.shade500
              ..style = PaintingStyle.fill,
          );
          print("ISS :$i");

          if (level != 1) {
            final borderPaint =
                Paint()
                  ..color = Colors.white
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2;
            canvas.drawPath(path, borderPaint);
          }
        } else if ((layerColors["blue"]![level - 1] & (1 << i)) != 0) {
          canvas.drawPath(
            path,
            Paint()
              ..color = Colors.blue.shade400
              ..style = PaintingStyle.fill,
          );
          final borderPaint =
              Paint()
                ..color = Colors.white
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2;
          canvas.drawPath(path, borderPaint);
        } else if ((layerColors["white"]![level - 1] & (1 << i)) != 0) {
          canvas.drawPath(
            path,
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.fill,
          );
          final borderPaint =
              Paint()
                ..color = Colors.grey.withValues(alpha: .10)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2;
          canvas.drawPath(path, borderPaint);
        }
      }
    }

    // Draw axis lines and tick dots
    for (int i = 0; i < 4; i++) {
      final angle = pi / 2 * i;
      final dx = cos(angle);
      final dy = sin(angle);
      final end = Offset(
        center.dx + dx * step * maxValue,
        center.dy + dy * step * maxValue,
      );

      // Draw dots
      for (int j = 2; j <= maxValue; j++) {
        if (j != 6) {
          final tick = Offset(
            center.dx + dx * step * j,
            center.dy + dy * step * j,
          );
          canvas.drawCircle(tick, dotRadius, dotPaint);
        }

        // 👇 Add this to show label at level 3 (C layout)
      } // Draw text

      for (int j = 2; j <= axisLabels.length - 1; j++) {
        final tick = Offset(
          center.dx + dx * step * j,
          center.dy + dy * step * j,
        );

        if (i == 0) {
          const double circleRadius = 10;

          // Background circle
          final circleCenter = Offset(
            tick.dx - dx * (dotRadius + circleRadius), // shift a bit outward
            tick.dy - dy * (dotRadius + circleRadius),
          );

          final circlePaint =
              Paint()
                ..color = Color(0XFF3C6080)
                ..style = PaintingStyle.fill;

          canvas.drawCircle(circleCenter, circleRadius, circlePaint);
          final textSpan = TextSpan(
            text: axisLabels[j - 1],
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
          final tp = TextPainter(
            text: textSpan,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );
          tp.layout();

          // 💡 Position text before the dot
          final labelOffset = Offset(
            tick.dx - tp.width / 1.2 - dx * 12,
            tick.dy - tp.height / 2 - dy * 12,
          );

          tp.paint(canvas, labelOffset);
        }
      }
    }

    const centerIcon = TextSpan(
      text: '🌱', // You can change to another emoji or text
      style: TextStyle(
        fontSize: 20
      ),
    );

    final iconPainter = TextPainter(
      text: centerIcon,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        center.dx - iconPainter.width / 2,
        center.dy - iconPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
