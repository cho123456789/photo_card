import 'dart:io';

import 'package:flutter/material.dart';

import '../../../domain/entities/member_binder.dart';
import '../../../domain/entities/photo_card.dart';
import 'binder_cover.dart';

class BinderDetail extends StatelessWidget {
  const BinderDetail({
    super.key,
    required this.binder,
    required this.cards,
    required this.onDelete,
    required this.onDeleteBinder,
    required this.onAddCard,
    required this.onDecorate,
    required this.onRecord,
  });

  final MemberBinder binder;
  final List<PhotoCard> cards;
  final Future<void> Function(PhotoCard card) onDelete;
  final Future<void> Function() onDeleteBinder;
  final VoidCallback onAddCard;
  final VoidCallback onDecorate;
  final ValueChanged<PhotoCard> onRecord;

  @override
  Widget build(BuildContext context) {
    final owned = cards.where((card) => card.isOwned).length;
    final progress = cards.isEmpty ? 0.0 : owned / cards.length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  binder.group,
                  style: TextStyle(
                    color: Color(binder.colorValue),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: '바인더 꾸미기',
                icon: const Icon(Icons.auto_awesome_outlined),
                onPressed: onDecorate,
              ),
              IconButton(
                tooltip: '카드 추가',
                icon: const Icon(Icons.add_photo_alternate_outlined),
                onPressed: onAddCard,
              ),
              IconButton(
                tooltip: '컬렉션 삭제',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmBinderDelete(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          BinderCover(binder: binder),
          const SizedBox(height: 16),
          Text(
            '$owned / ${cards.length} 보유',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: Color(binder.colorValue),
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 700
                  ? 6
                  : constraints.maxWidth >= 460
                  ? 5
                  : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: .68,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (_, index) => _PhotoCardTile(
                  card: cards[index],
                color: Color(binder.colorValue),
                onRemovePhoto: () => onDelete(cards[index]),
                onRecord: () => onRecord(cards[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmBinderDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${binder.name} 컬렉션을 삭제할까요?'),
        content: const Text('컬렉션 안의 모든 포토카드 사진도 함께 삭제되며 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed == true) await onDeleteBinder();
  }
}

class _PhotoCardTile extends StatelessWidget {
  const _PhotoCardTile({
    required this.card,
    required this.color,
    required this.onRemovePhoto,
    required this.onRecord,
  });

  final PhotoCard card;
  final Color color;
  final Future<void> Function() onRemovePhoto;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Stack(
      fit: StackFit.expand,
      children: [
        card.isOwned ? _ownedCard(context) : _missingCard(),
        Positioned(
          left: 2,
          bottom: 2,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: '카드 기록',
              color: Colors.white,
              icon: const Icon(Icons.edit_note_outlined, size: 14),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 24, height: 24),
              onPressed: onRecord,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _missingCard() => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: .15),
      border: Border.all(color: color.withValues(alpha: .55)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_outlined, color: color, size: 18),
          const SizedBox(height: 3),
          Text(
            card.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 8),
          ),
          const SizedBox(height: 2),
          const Text(
            '미보유',
            style: TextStyle(fontSize: 8, color: Colors.white54),
          ),
        ],
      ),
    ),
  );

  Widget _ownedCard(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      GestureDetector(
        onTap: () => _openViewer(context),
        child: Image.file(
          File(card.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => ColoredBox(color: color),
        ),
      ),
      Positioned(
        top: 2,
        right: 2,
        child: Material(
          color: Colors.black54,
          shape: const CircleBorder(),
          child: IconButton(
            tooltip: '등록 사진 삭제',
            color: Colors.white,
            icon: const Icon(Icons.delete_outline, size: 14),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 24, height: 24),
            onPressed: () => _confirmRemovePhoto(context),
          ),
        ),
      ),
    ],
  );

  Future<void> _confirmRemovePhoto(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('등록 사진을 삭제할까요?'),
        content: const Text('카드 슬롯은 유지되고 미보유 상태로 바뀝니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed == true) await onRemovePhoto();
  }

  void _openViewer(BuildContext context) => showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            child: Center(
              child: Image.file(File(card.imagePath!), fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
