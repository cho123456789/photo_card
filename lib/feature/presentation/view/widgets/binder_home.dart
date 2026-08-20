import 'package:flutter/material.dart';

import '../../../domain/entities/member_binder.dart';
import '../../../domain/entities/photo_card.dart';
import 'binder_cover.dart';

class BinderHome extends StatelessWidget {
  const BinderHome({super.key, required this.binders, required this.cards, required this.onOpen, required this.onCreate, required this.onDelete, required this.onRename});
  final List<MemberBinder> binders;
  final List<PhotoCard> cards;
  final ValueChanged<String> onOpen;
  final VoidCallback onCreate;
  final Future<void> Function(MemberBinder binder) onDelete;
  final void Function(MemberBinder binder, String name) onRename;

  @override
  Widget build(BuildContext context) {
    if (binders.isEmpty) return _EmptyCollection(onCreate: onCreate);
    final ownedCount = cards.where((card) => card.isOwned).length;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          sliver: SliverToBoxAdapter(child: _HomeIntro(binderCount: binders.length, cardCount: ownedCount)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.crossAxisExtent > 600 ? 3 : 2;
              return SliverGrid.builder(
                itemCount: binders.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 14, mainAxisSpacing: 18, childAspectRatio: .72),
                itemBuilder: (context, index) {
                  if (index == binders.length) return _CreateBinderTile(onTap: onCreate);
                  final binder = binders[index];
                  final binderCards = cards.where((card) => card.memberId == binder.id).toList();
                  return _BinderTile(binder: binder, cards: binderCards, onTap: () => onOpen(binder.id), onDelete: () => _confirmDelete(context, binder), onRename: () => _renameBinder(context, binder));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, MemberBinder binder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${binder.name} 바인더를 삭제할까요?'),
        content: const Text('바인더 안의 카드 기록과 사진도 함께 삭제됩니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('취소')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('삭제')),
        ],
      ),
    );
    if (confirmed == true) await onDelete(binder);
  }

  Future<void> _renameBinder(BuildContext context, MemberBinder binder) async {
    final controller = TextEditingController(text: binder.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('바인더 이름 수정'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(hintText: '바인더 이름'),
          onSubmitted: (value) => Navigator.pop(dialogContext, value),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('취소')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, controller.text), child: const Text('저장')),
        ],
      ),
    );
    final trimmedName = name?.trim();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
      if (trimmedName?.isNotEmpty == true) {
        onRename(binder, trimmedName!);
      }
    });
  }
}

class _HomeIntro extends StatelessWidget {
  const _HomeIntro({required this.binderCount, required this.cardCount});
  final int binderCount;
  final int cardCount;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('나의 컬렉션', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text('좋아하는 순간들을 한 권씩 모아보세요.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white60)),
      const SizedBox(height: 18),
      Wrap(spacing: 8, runSpacing: 8, children: [
        _SummaryChip(icon: Icons.menu_book_outlined, label: '$binderCount개 바인더'),
        _SummaryChip(icon: Icons.photo_outlined, label: '$cardCount장 수집'),
      ]),
    ],
  );
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .07), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white.withValues(alpha: .08))),
    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16, color: Colors.white70), const SizedBox(width: 6), Text(label, style: const TextStyle(fontWeight: FontWeight.w600))])),
  );
}

class _BinderTile extends StatelessWidget {
  const _BinderTile({required this.binder, required this.cards, required this.onTap, required this.onDelete, required this.onRename});
  final MemberBinder binder;
  final List<PhotoCard> cards;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    final owned = cards.where((card) => card.isOwned).length;
    final color = Color(binder.colorValue);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          Positioned.fill(child: BinderCover(binder: binder, compact: true)),
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.black.withValues(alpha: .35),
              shape: const CircleBorder(),
              child: PopupMenuButton<_BinderMenuAction>(
                tooltip: '바인더 메뉴',
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                onSelected: (action) => action == _BinderMenuAction.rename ? onRename() : onDelete(),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: _BinderMenuAction.rename, child: ListTile(leading: Icon(Icons.edit_outlined), title: Text('이름 수정'))),
                  PopupMenuItem(value: _BinderMenuAction.delete, child: ListTile(leading: Icon(Icons.delete_outline), title: Text('삭제'))),
                ],
              ),
            ),
          ),
          Positioned(left: 14, right: 14, bottom: 12, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(binder.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 7),
            Row(children: [Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: cards.isEmpty ? 0 : owned / cards.length, minHeight: 5, color: color, backgroundColor: Colors.white24))), const SizedBox(width: 8), Text('$owned장', style: const TextStyle(fontSize: 12, color: Colors.white70))]),
          ])),
        ]),
      ),
    );
  }
}

enum _BinderMenuAction { rename, delete }

class _CreateBinderTile extends StatelessWidget {
  const _CreateBinderTile({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: .04),
    borderRadius: BorderRadius.circular(24),
    child: InkWell(borderRadius: BorderRadius.circular(24), onTap: onTap, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add_circle_outline, size: 40, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 10), const Text('새 바인더', style: TextStyle(fontWeight: FontWeight.w700))]))),
  );
}

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection({required this.onCreate});
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(Icons.auto_awesome_mosaic_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
    const SizedBox(height: 18),
    Text('첫 번째 바인더를 만들어보세요', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
    const SizedBox(height: 8),
    const Text('소중한 포토카드를 한곳에 모아\n나만의 컬렉션을 시작해보세요.', textAlign: TextAlign.center),
    const SizedBox(height: 24),
    FilledButton.icon(onPressed: onCreate, icon: const Icon(Icons.add), label: const Text('바인더 만들기')),
  ])));
}
