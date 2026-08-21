import 'dart:math' as math;

import 'package:flutter/material.dart';

class PaperBackground extends StatelessWidget {
  const PaperBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xfff3eee5)),
          CustomPaint(painter: _PaperTexturePainter()),
          child,
        ],
      );
}

class _PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(17);
    final fiberPaint = Paint()
      ..color = const Color(0xff8d8172).withOpacity(.055)
      ..strokeWidth = .65
      ..strokeCap = StrokeCap.round;
    final dotPaint = Paint()
      ..color = const Color(0xff75695d).withOpacity(.045);

    final count = (size.width * size.height / 8500).round();
    for (var i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      if (i.isEven) {
        final length = 3 + random.nextDouble() * 10;
        final angle = (random.nextDouble() - .5) * .35;
        canvas.drawLine(
          Offset(x, y),
          Offset(x + math.cos(angle) * length, y + math.sin(angle) * length),
          fiberPaint,
        );
      } else {
        canvas.drawCircle(Offset(x, y), .45 + random.nextDouble() * .7, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
