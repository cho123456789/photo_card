import 'dart:io';

import 'package:flutter/material.dart';

import '../../../domain/entities/member_binder.dart';

class BinderCover extends StatelessWidget {
  const BinderCover({super.key, required this.binder, this.compact = false});

  final MemberBinder binder;
  final bool compact;

  static const themes = <String, ({String label, List<Color> colors})>{
    'glitter': (label: 'Glitter', colors: [Color(0xfff275a5), Color(0xff8b70eb)]),
    'concert': (label: 'Concert', colors: [Color(0xff17132d), Color(0xff5f39a6)]),
    'pastel': (label: 'Pastel check', colors: [Color(0xfff4b6c9), Color(0xff9bc5ee)]),
    'album': (label: 'Album mood', colors: [Color(0xffe6af60), Color(0xffce6577)]),
  };

  @override
  Widget build(BuildContext context) {
    final theme = themes[binder.themeId] ?? themes['glitter']!;
    final hasCover = binder.coverImagePath != null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 12 : 20),
      child: AspectRatio(
        aspectRatio: compact ? .78 : 1.65,
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
            Positioned(
              top: compact ? 8 : 16,
              right: compact ? 8 : 18,
              child: Wrap(
                spacing: 2,
                children: binder.stickerIds
                    .map(
                      (id) => Text(
                        _sticker(id),
                        style: TextStyle(fontSize: compact ? 14 : 25),
                      ),
                    )
                    .toList(),
              ),
            ),
            Positioned(
              left: compact ? 10 : 22,
              right: compact ? 10 : 22,
              bottom: compact ? 10 : 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    binder.coverTitle?.isNotEmpty == true ? binder.coverTitle! : binder.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: compact ? 14 : 27, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    binder.coverSubtitle?.isNotEmpty == true ? binder.coverSubtitle! : binder.group,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white.withValues(alpha: .86), fontSize: compact ? 9 : 13),
                  ),
                ],
              ),
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

  String _sticker(String id) => switch (id) {
    'heart' => '♥',
    'ribbon' => '🎀',
    'star' => '★',
    _ => '✦',
  };

}
