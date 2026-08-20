import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
    return WillPopScope(
      onWillPop: () => _handleBack(context, notifier, selected != null),
      child: Scaffold(
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
              onRename: (binder, name) => notifier.renameBinder(
                binderId: binder.id,
                name: name,
              ),
            )
            : BinderDetail(
              binder: selected,
              cards: state.cards
                  .where((card) => card.memberId == selected.id)
                  .toList(),
              onDelete: notifier.deleteCard,
              onDeleteBinder: () => notifier.deleteBinder(selected),
              onRenameBinder: (name) => notifier.renameBinder(
                binderId: selected.id,
                name: name,
              ),
              onAddCard: () => _createCard(context, ref, selected.id),
              onDecorate: () => _decorateBinder(context, ref, selected),
              onRecord: (card) => _recordCard(context, ref, card),
              onRegisterCard: (card) => _registerSlot(context, ref, card),
              ),
      ),
    );
  }

  Future<bool> _handleBack(
    BuildContext context,
    BinderNotifier notifier,
    bool isViewingBinder,
  ) async {
    if (isViewingBinder) {
      notifier.closeBinder();
      return false;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('앱을 종료할까요?'),
        content: const Text('현재 기기의 컬렉션 데이터는 그대로 유지됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('종료'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
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
    final source = await showModalBottomSheet<_PhotoRegistrationSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.document_scanner_outlined),
              title: const Text('카메라로 등록'),
              subtitle: const Text('포토카드를 촬영하고 자동으로 보정합니다.'),
              onTap: () => Navigator.pop(
                sheetContext,
                _PhotoRegistrationSource.camera,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('앨범에서 선택'),
              subtitle: const Text('기기에 저장된 사진을 선택합니다.'),
              onTap: () => Navigator.pop(
                sheetContext,
                _PhotoRegistrationSource.gallery,
              ),
            ),
          ],
        ),
      ),
    );
    if (source == null || !context.mounted) return;

    final notifier = ref.read(binderProvider.notifier);
    notifier.setSaving(true);
    try {
      final imagePath = switch (source) {
        _PhotoRegistrationSource.camera => await ref
            .read(photocardScannerProvider)
            .scanAndStore(),
        _PhotoRegistrationSource.gallery => await _pickPhotoFromGallery(),
      };
      if (imagePath != null) {
        notifier.registerCardPhoto(cardId: card.id, imagePath: imagePath);
      }
    } finally {
      notifier.setSaving(false);
    }
  }

  Future<String?> _pickPhotoFromGallery() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 92,
    );
    if (picked == null) return null;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 68, ratioY: 100),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 92,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '포토카드 자르기',
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: '포토카드 자르기',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
    if (cropped == null) return null;

    final documents = await getApplicationDocumentsDirectory();
    final folder = Directory(
      '${documents.path}${Platform.pathSeparator}photocard_binder',
    );
    if (!await folder.exists()) await folder.create(recursive: true);

    final destination = File(
      '${folder.path}${Platform.pathSeparator}card_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await File(cropped.path).copy(destination.path);
    return destination.path;
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

enum _PhotoRegistrationSource { camera, gallery }
