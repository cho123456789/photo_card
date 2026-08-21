import 'dart:io';

import 'package:flutter/material.dart';

import '../../../domain/entities/member_binder.dart';

class BinderCover extends StatelessWidget {
  const BinderCover({super.key, required this.binder, this.compact = false});

  final MemberBinder binder;
  final bool compact;

  static const themes = <String, ({String label, List<Color> colors})>{
    'glitter': (label: 'Holographic', colors: [Color(0xfff275a5), Color(0xff8b70eb)]),
    'concert': (label: 'Leather', colors: [Color(0xff17132d), Color(0xff5f39a6)]),
    'pastel': (label: 'Checkered', colors: [Color(0xfff4b6c9), Color(0xff9bc5ee)]),
    'album': (label: 'Denim', colors: [Color(0xff4f7896), Color(0xff243f5d)]),
  };

  @override
  Widget build(BuildContext context) {
    final theme = themes[binder.themeId] ?? themes['glitter']!;
    final hasCover = binder.coverImagePath != null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 12 : 20),
      child: AspectRatio(
        aspectRatio: compact ? .78 : .72,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasCover)
              Image.file(
                File(binder.coverImagePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _themeBackground(theme.colors),
              )
            else
              _themeBackground(theme.colors),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: .70), Colors.transparent],
                ),
              ),
            ),
            CustomPaint(
              painter: _CoverTexturePainter(
                themeId: binder.themeId,
                color: Colors.white.withValues(alpha: hasCover ? .10 : .18),
              ),
            ),
            _BinderSpine(compact: compact, color: Colors.black.withValues(alpha: .18)),
            if (!compact)
              Positioned(
                top: 22,
                right: 18,
                child: _StickerBadge(label: '♡', color: Colors.white.withValues(alpha: .88)),
              ),
            if (!compact)
              Positioned(
                right: 18,
                bottom: 18,
                child: _DateBadge(year: DateTime.now().year),
              ),
          ],
        ),
      ),
    );
  }

  Widget _themeBackground(List<Color> colors) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
    ),
  );
}

class _BinderSpine extends StatelessWidget {
  const _BinderSpine({required this.compact, required this.color});

  final bool compact;
  final Color color;

  @override
  Widget build(BuildContext context) => Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        width: compact ? 22 : 34,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            border: Border(right: BorderSide(color: Colors.white.withValues(alpha: .22))),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              compact ? 4 : 5,
              (_) => Container(
                width: compact ? 9 : 13,
                height: compact ? 9 : 13,
                decoration: BoxDecoration(
                  color: const Color(0xffe9ded0).withValues(alpha: .82),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black.withValues(alpha: .24), width: 1.2),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 1))],
                ),
              ),
            ),
          ),
        ),
      );
}

class _StickerBadge extends StatelessWidget {
  const _StickerBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: -.12,
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(1, 2))]),
          child: Text(label, style: const TextStyle(color: Color(0xffb14f71), fontSize: 23, fontWeight: FontWeight.bold)),
        ),
      );
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(color: const Color(0xfff7ead7).withValues(alpha: .9), borderRadius: BorderRadius.circular(4), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 2))]),
        child: Text('EST. $year', style: const TextStyle(color: Color(0xff55463d), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
      );
}

class _CoverTexturePainter extends CustomPainter {
  const _CoverTexturePainter({required this.themeId, required this.color});

  final String themeId;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    if (themeId == 'pastel') {
      for (var x = 0.0; x < size.width; x += 22) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      for (var y = 0.0; y < size.height; y += 22) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    } else if (themeId == 'glitter') {
      for (var x = -size.height; x < size.width; x += 18) canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), paint);
    } else if (themeId == 'album') {
      for (var x = 0.0; x < size.width; x += 15) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      for (var y = 0.0; y < size.height; y += 15) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    } else {
      final grain = Paint()..color = color.withValues(alpha: .28)..strokeWidth = .7;
      for (var y = 6.0; y < size.height; y += 9) canvas.drawLine(Offset(0, y), Offset(size.width, y + 2), grain);
    }
  }

  @override
  bool shouldRepaint(covariant _CoverTexturePainter oldDelegate) => oldDelegate.themeId != themeId || oldDelegate.color != color;
}
