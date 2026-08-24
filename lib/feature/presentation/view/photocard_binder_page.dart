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
import 'widgets/paper_background.dart';

class PhotocardBinderPage extends StatelessWidget {
  const PhotocardBinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = BinderScope.of(context);
    final state = notifier.state;
    final selected = state.selectedBinderId == null
        ? null
        : state.binders
              .where((binder) => binder.id == state.selectedBinderId)
              .firstOrNull;
    return WillPopScope(
      onWillPop: () => _handleBack(context, notifier, selected != null),
      child: Scaffold(
        backgroundColor: const Color(0xfff3eee5),
        appBar: AppBar(
        backgroundColor: const Color(0xfff3eee5),
        foregroundColor: const Color(0xff332e29),
        surfaceTintColor: Colors.transparent,
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
            onPressed: () => _createCollection(context, notifier),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
        body: PaperBackground(
          child: selected == null
              ? BinderHome(
                  binders: state.binders,
                  cards: state.cards,
                  onOpen: notifier.openBinder,
                  onCreate: () => _createCollection(context, notifier),
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
                  onAddCard: (album) => _createCard(
                    context,
                    notifier,
                    selected.id,
                    album: album,
                  ),
                  onDecorate: () => _decorateBinder(context, notifier, selected),
                  onRecord: (card) => _recordCard(context, notifier, card),
                  onRegisterCard: (card) => _registerSlot(context, notifier, card),
                ),
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
    BinderNotifier notifier,
    PhotoCard card,
  ) async {
    final input = await showPhotoCardRecordDialog(context, card);
    if (input == null || !context.mounted) return;
    await _waitForOverlayToClose();
    if (!context.mounted) return;
    notifier.updateCardRecord(
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
    BinderNotifier notifier,
    MemberBinder binder,
  ) async {
    final input = await showBinderDecorationSheet(
      context,
      binder: binder,
    );
    if (input == null || !context.mounted) return;
    await _waitForOverlayToClose();
    if (!context.mounted) return;
    notifier.decorateBinder(
      binderId: binder.id,
      coverImagePath: input.coverImagePath,
      clearCoverImage: input.clearCoverImage,
      coverTitle: input.coverTitle,
      coverSubtitle: input.coverSubtitle,
      themeId: input.themeId,
    );
  }

  Future<void> _createCollection(BuildContext context, BinderNotifier notifier) async {
    final input = await showCreateBinderDialog(context);
    if (input == null || !context.mounted) return;
    await _waitForOverlayToClose();
    if (!context.mounted) return;
    notifier.addBinder(
          name: input.name,
          group: input.group,
        );
  }

  Future<void> _registerSlot(
    BuildContext context,
    BinderNotifier notifier,
    PhotoCard card,
    {bool showRegistrationDialog = true}
  ) async {
    CreatePhotoCardInput? registration;
    if (showRegistrationDialog) {
      registration = await showCreatePhotoCardDialog(
      context,
      initialAlbum: card.album,
      initialTitle: card.title,
      );
      if (registration == null || !context.mounted) return;
      await _waitForOverlayToClose();
      if (!context.mounted) return;
    }

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

    notifier.setSaving(true);
    try {
    final imagePath = switch (source) {
        _PhotoRegistrationSource.camera => await ProviderScope.containerOf(
          context,
          listen: false,
        ).read(photocardScannerProvider)
            .scanAndStore(),
        _PhotoRegistrationSource.gallery => await _pickPhotoFromGallery(),
    };
    if (imagePath != null) {
        await _waitForOverlayToClose();
        if (!context.mounted) return;
        if (registration != null) {
          notifier.updateCardRecord(
            cardId: card.id,
            album: registration.album,
            version: registration.version,
            benefitSource: registration.benefitSource,
            acquiredAt: card.acquiredAt ?? DateTime.now(),
            price: card.price,
            memo: registration.memo,
          );
        }
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
    BinderNotifier notifier,
    String collectionId,
    {String? album}
  ) async {
    final input = await showCreatePhotoCardDialog(
      context,
      initialAlbum: album,
    );
    if (input == null || !context.mounted) return;
    await _waitForOverlayToClose();
    if (!context.mounted) return;
    final card = notifier.addCard(
      collectionId: collectionId,
      title: input.version.isEmpty
          ? input.title
          : '${input.title} · ${input.version}',
      album: input.album.isEmpty ? album ?? '' : input.album,
      benefitSource: input.benefitSource,
      memo: input.memo,
    );
    await _registerSlot(
      context,
      notifier,
      card,
      showRegistrationDialog: false,
    );
  }

  Future<void> _waitForOverlayToClose() =>
      Future<void>.delayed(const Duration(milliseconds: 250));

}

enum _PhotoRegistrationSource { camera, gallery }
