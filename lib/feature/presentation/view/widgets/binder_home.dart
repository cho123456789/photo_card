import 'package:flutter/material.dart';

import '../../../domain/entities/member_binder.dart';
import '../../../domain/entities/photo_card.dart';
import 'binder_cover.dart';

class BinderHome extends StatelessWidget {
  const BinderHome({
    super.key,
    required this.binders,
    required this.cards,
    required this.onOpen,
    required this.onCreate,
    required this.onDelete,
  });

  final List<MemberBinder> binders;
  final List<PhotoCard> cards;
  final ValueChanged<String> onOpen;
  final VoidCallback onCreate;
  final Future<void> Function(MemberBinder binder) onDelete;

  @override
  Widget build(BuildContext context) {
    if (binders.isEmpty) return _EmptyCollection(onCreate: onCreate);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('내 앨범 컬렉션', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('미보유 포토카드 슬롯을 사진으로 채워 컬렉션을 완성해 보세요.'),
        const SizedBox(height: 20),
        ...binders.map((binder) {
          final collectionCards = cards
              .where((card) => card.memberId == binder.id)
              .toList();
          final owned = collectionCards.where((card) => card.isOwned).length;
          final progress = collectionCards.isEmpty
              ? 0.0
              : owned / collectionCards.length;
          return Card(
            color: Color(binder.colorValue).withValues(alpha: .23),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: SizedBox(
                width: 58,
                child: BinderCover(binder: binder, compact: true),
              ),
              title: Text(
                binder.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(binder.group),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    color: Color(binder.colorValue),
                  ),
                  const SizedBox(height: 3),
                  Text('$owned / ${collectionCards.length} 보유'),
                ],
              ),
              trailing: IconButton(
                tooltip: '컬렉션 삭제',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, binder),
              ),
              onTap: () => onOpen(binder.id),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, MemberBinder binder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${binder.name} 컬렉션을 삭제할까요?'),
        content: const Text('컬렉션 안의 등록 사진도 함께 삭제됩니다.'),
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
    if (confirmed == true) await onDelete(binder);
  }
}

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 240,
      height: 64,
      child: FilledButton.icon(
        onPressed: onCreate,
        icon: const Icon(Icons.add, size: 28),
        label: const Text(
          '컬렉션 만들기',
          style: TextStyle(fontSize: 18),
        ),
      ),
    ),
  );
}
