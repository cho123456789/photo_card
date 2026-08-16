import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/member_binder.dart';
import '../../domain/entities/photo_card.dart';
import '../provider/binder_provider.dart';
import '../provider/photocard_scanner_provider.dart';
import 'widgets/binder_actions.dart';
import 'widgets/binder_detail.dart';
import 'widgets/binder_home.dart';
import 'widgets/binder_statistics.dart';

class PhotocardBinderPage extends ConsumerWidget {
  const PhotocardBinderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(binderProvider);
    final notifier = ref.read(binderProvider.notifier);
    final selected = state.selectedBinderId == null
        ? null
        : state.binders
              .where((binder) => binder.id == state.selectedBinderId)
              .firstOrNull;
    return Scaffold(
      appBar: AppBar(
        leading: selected == null
            ? null
            : IconButton(
                onPressed: notifier.closeBinder,
                icon: const Icon(Icons.arrow_back),
              ),
        title: Text(selected?.name ?? '포토카드 바인더'),
        actions: [
          if (selected == null)
            IconButton(
              tooltip: '통계',
              icon: const Icon(Icons.bar_chart_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BinderStatisticsPage(
                    binders: state.binders,
                    cards: state.cards,
                  ),
                ),
              ),
            ),
          IconButton(
            tooltip: '컬렉션 만들기',
            onPressed: () => _createCollection(context, ref),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: selected == null
          ? BinderHome(
              binders: state.binders,
              cards: state.cards,
              onOpen: notifier.openBinder,
              onCreate: () => _createCollection(context, ref),
              onDelete: notifier.deleteBinder,
            )
          : BinderDetail(
              binder: selected,
              cards: state.cards
                  .where((card) => card.memberId == selected.id)
                  .toList(),
              onDelete: notifier.deleteCard,
              onDeleteBinder: () => notifier.deleteBinder(selected),
              onAddCard: () => _createCard(context, ref, selected.id),
              onDecorate: () => _decorateBinder(context, ref, selected),
              onRecord: (card) => _recordCard(context, ref, card),
              onRegisterCard: (card) => _registerSlot(context, ref, card),
            ),
    );
  }

  Future<void> _recordCard(
    BuildContext context,
    WidgetRef ref,
    PhotoCard card,
  ) async {
    final input = await showPhotoCardRecordDialog(context, card);
    if (input == null || !context.mounted) return;
    ref.read(binderProvider.notifier).updateCardRecord(
      cardId: card.id,
      album: input.album,
      version: input.version,
      benefitSource: input.benefitSource,
      acquiredAt: input.acquiredAt,
      price: input.price,
      memo: input.memo,
    );
  }

  Future<void> _decorateBinder(
    BuildContext context,
    WidgetRef ref,
    MemberBinder binder,
  ) async {
    final input = await showBinderDecorationSheet(
      context,
      binder: binder,
    );
    if (input == null || !context.mounted) return;
    ref.read(binderProvider.notifier).decorateBinder(
      binderId: binder.id,
      coverImagePath: input.coverImagePath,
      clearCoverImage: input.clearCoverImage,
      coverTitle: input.coverTitle,
      coverSubtitle: input.coverSubtitle,
      themeId: input.themeId,
    );
  }

  Future<void> _createCollection(BuildContext context, WidgetRef ref) async {
    final input = await showCreateBinderDialog(context);
    if (input == null || !context.mounted) return;
    ref
        .read(binderProvider.notifier)
        .addBinder(name: input.name, group: input.group);
  }

  Future<void> _registerSlot(
    BuildContext context,
    WidgetRef ref,
    PhotoCard card,
  ) async {
    final notifier = ref.read(binderProvider.notifier);
    notifier.setSaving(true);
    try {
      final imagePath = await ref.read(photocardScannerProvider).scanAndStore();
      if (imagePath != null) {
        notifier.registerCardPhoto(cardId: card.id, imagePath: imagePath);
      }
    } finally {
      notifier.setSaving(false);
    }
  }

  Future<void> _createCard(
    BuildContext context,
    WidgetRef ref,
    String collectionId,
  ) async {
    final input = await showCreatePhotoCardDialog(context);
    if (input == null || !context.mounted) return;
    final notifier = ref.read(binderProvider.notifier);
    final card = notifier.addCard(
      collectionId: collectionId,
      title: input.title,
      memo: input.memo,
    );
    await _registerSlot(context, ref, card);
  }

}
