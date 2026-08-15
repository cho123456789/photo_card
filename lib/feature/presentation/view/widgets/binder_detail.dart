import 'dart:io';

import 'package:flutter/material.dart';

import '../../../domain/entities/member_binder.dart';
import '../../../domain/entities/photo_card.dart';
import 'binder_cover.dart';

class BinderDetail extends StatelessWidget {
  const BinderDetail({
    super.key,
    required MemberBinder binder,
    required this.cards,
    required this.onDelete,
    required this.onDeleteBinder,
    required this.onAddCard,
    required this.onDecorate,
    required this.onRecord,
    required this.onRegisterCard,
  }) : _binder = binder;

  final MemberBinder _binder;
  final List<PhotoCard> cards;
  final Future<void> Function(PhotoCard card) onDelete;
  final Future<void> Function() onDeleteBinder;
  final VoidCallback onAddCard;
  final VoidCallback onDecorate;
  final ValueChanged<PhotoCard> onRecord;
  final Future<void> Function(PhotoCard card) onRegisterCard;

  @override
  Widget build(BuildContext context) {
    final owned = cards.where((card) => card.isOwned).length;
    final progress = cards.isEmpty ? 0.0 : owned / cards.length;
    return PageView(
      children: [
        _buildCoverPage(context, owned, progress),
        _buildBinderPage(context, owned, progress),
      ],
    );
  }

  Widget _buildCoverPage(BuildContext context, int owned, double progress) =>
      SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _binder.group,
                  style: TextStyle(
                    color: Color(_binder.colorValue),
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
                tooltip: '컬렉션 삭제',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmBinderDelete(context, _binder.name),
              ),
            ],
          ),
          const SizedBox(height: 4),
          BinderCover(binder: _binder),
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
              color: Color(_binder.colorValue),
            ),
          ),
          const SizedBox(height: 28),
          Center(
            child: Column(
              children: [
                const Icon(Icons.arrow_back),
                const SizedBox(height: 6),
                Text(
                  '왼쪽으로 넘겨 포토카드 바인더 보기',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _buildBinderPage(BuildContext context, int owned, double progress) =>
      SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '포토카드 바인더',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            Text('$owned / ${cards.length} 보유'),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                color: Color(_binder.colorValue),
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length < 16 ? 16 : cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: .68,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, index) => index < cards.length
                  ? _PhotoCardTile(
                      card: cards[index],
                      color: Color(_binder.colorValue),
                      onRemovePhoto: () => onDelete(cards[index]),
                      onRecord: () => onRecord(cards[index]),
                      onRegister: () => onRegisterCard(cards[index]),
                    )
                  : _EmptyPhotoCardSlot(
                      color: Color(_binder.colorValue),
                      onTap: onAddCard,
                    ),
            ),
          ],
        ),
      );

  Future<void> _confirmBinderDelete(
    BuildContext context,
    String binderName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$binderName 컬렉션을 삭제할까요?'),
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

class _EmptyPhotoCardSlot extends StatelessWidget {
  const _EmptyPhotoCardSlot({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Icon(
        Icons.add_photo_alternate_outlined,
        color: color.withValues(alpha: .6),
      ),
    ),
  );
}

class _PhotoCardTile extends StatelessWidget {
  const _PhotoCardTile({
    required this.card,
    required this.color,
    required this.onRemovePhoto,
    required this.onRecord,
    required this.onRegister,
  });

  final PhotoCard card;
  final Color color;
  final Future<void> Function() onRemovePhoto;
  final VoidCallback onRecord;
  final Future<void> Function() onRegister;

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

  Widget _missingCard() => GestureDetector(
    onTap: onRegister,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        border: Border.all(color: color.withValues(alpha: .55)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, color: color, size: 18),
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
              '탭하여 등록',
              style: TextStyle(fontSize: 8, color: Colors.white54),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _ownedCard(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Image.file(
        File(card.imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => ColoredBox(color: color),
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
        content: const Text('등록 사진과 카드 이름·버전·설명 등 모든 기록이 삭제됩니다.'),
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

}
