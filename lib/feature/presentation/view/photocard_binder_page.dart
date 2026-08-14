import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/member_binder.dart';
import '../../domain/entities/photo_card.dart';
import '../provider/binder_provider.dart';
import '../provider/photocard_scanner_provider.dart';
import 'widgets/binder_actions.dart';
import 'widgets/binder_detail.dart';
import 'widgets/binder_home.dart';

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
            ),
      floatingActionButton: _ScanButton(
        isSaving: state.isSaving,
        hasCollections: state.binders.isNotEmpty,
        onCreate: () => _createCollection(context, ref),
        onScan: () => _selectCardAndScan(context, ref),
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
      cards: ref
          .read(binderProvider)
          .cards
          .where((card) => card.memberId == binder.id)
          .toList(),
    );
    if (input == null || !context.mounted) return;
    ref.read(binderProvider.notifier).decorateBinder(
      binderId: binder.id,
      coverImagePath: input.coverImagePath,
      clearCoverImage: input.clearCoverImage,
      coverTitle: input.coverTitle,
      coverSubtitle: input.coverSubtitle,
      themeId: input.themeId,
      stickerIds: input.stickerIds,
    );
  }

  Future<void> _createCollection(BuildContext context, WidgetRef ref) async {
    final input = await showCreateBinderDialog(context);
    if (input == null || !context.mounted) return;
    ref
        .read(binderProvider.notifier)
        .addBinder(name: input.name, group: input.group);
  }

  Future<void> _createCard(
    BuildContext context,
    WidgetRef ref,
    String collectionId,
  ) async {
    final input = await showCreatePhotoCardDialog(context);
    if (input == null || !context.mounted) return;
    ref
        .read(binderProvider.notifier)
        .addCard(collectionId: collectionId, title: input.title);
  }

  Future<void> _selectCardAndScan(BuildContext context, WidgetRef ref) async {
    final collectionId = await showMemberPicker(
      context,
      ref.read(binderProvider).binders,
    );
    if (collectionId == null || !context.mounted) return;
    final cardId = await showMissingCardPicker(
      context,
      ref
          .read(binderProvider)
          .cards
          .where((card) => card.memberId == collectionId)
          .toList(),
    );
    if (cardId == null || !context.mounted) return;

    final notifier = ref.read(binderProvider.notifier);
    notifier.setSaving(true);
    try {
      final imagePath = await ref.read(photocardScannerProvider).scanAndStore();
      if (imagePath != null) {
        notifier.registerCardPhoto(cardId: cardId, imagePath: imagePath);
        final card = ref
            .read(binderProvider)
            .cards
            .firstWhere((item) => item.id == cardId);
        if (context.mounted) await _recordCard(context, ref, card);
      }
    } finally {
      notifier.setSaving(false);
    }
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({
    required this.isSaving,
    required this.hasCollections,
    required this.onCreate,
    required this.onScan,
  });
  final bool isSaving;
  final bool hasCollections;
  final VoidCallback onCreate;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
    onPressed: isSaving ? null : (hasCollections ? onScan : onCreate),
    icon: isSaving
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          )
        : Icon(hasCollections ? Icons.document_scanner : Icons.add),
    label: Text(hasCollections ? '포토카드 등록' : '컬렉션 만들기'),
  );
}
