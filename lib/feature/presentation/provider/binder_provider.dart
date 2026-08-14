import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/repositories/local_binder_repository.dart';
import '../../domain/catalog/group_catalog.dart';
import '../../domain/entities/binder_collection.dart';
import '../../domain/entities/member_binder.dart';
import '../../domain/entities/photo_card.dart';
import '../../domain/repositories/binder_repository.dart';
import '../../domain/usecases/create_member_binder.dart';
import '../../domain/usecases/create_photo_card.dart';

part 'binder_provider.freezed.dart';

final binderRepositoryProvider = Provider<BinderRepository>(
  (ref) => LocalBinderRepository(),
);

@freezed
abstract class BinderState with _$BinderState {
  const factory BinderState({
    required List<MemberBinder> binders,
    required List<PhotoCard> cards,
    @Default([]) List<String> groupIds,
    String? selectedBinderId,
    @Default(false) bool isSaving,
    @Default(0) int tab,
  }) = _BinderState;
}

final binderProvider = NotifierProvider<BinderNotifier, BinderState>(
  BinderNotifier.new,
);

class BinderNotifier extends Notifier<BinderState> {
  static const _colors = [
    0xffef8cac,
    0xff8094f5,
    0xffe4b365,
    0xff69b9a8,
    0xffa98ae8,
  ];
  late final BinderRepository _repository;
  final _createMemberBinder = const CreateMemberBinder();
  final _createPhotoCard = const CreatePhotoCard();

  @override
  BinderState build() {
    _repository = ref.read(binderRepositoryProvider);
    Future<void>.microtask(_restore);
    return const BinderState(binders: [], cards: []);
  }

  void addGroup(GroupCatalog catalog) {
    if (state.groupIds.contains(catalog.id)) return;
    final data = catalog.buildCollection();
    state = state.copyWith(
      groupIds: [...state.groupIds, catalog.id],
      binders: [...state.binders, ...data.binders],
      cards: [...state.cards, ...data.cards],
    );
    _save();
  }

  void addBinder({required String name, required String group}) {
    final binder = _createMemberBinder(
      name: name,
      group: group,
      colorValue: _colors[state.binders.length % _colors.length],
    );
    state = state.copyWith(binders: [...state.binders, binder]);
    _save();
  }

  void addCard({
    required String collectionId,
    required String title,
    String album = '',
    String version = '',
    String benefitSource = '',
    DateTime? acquiredAt,
    String price = '',
    String memo = '',
  }) {
    final card = _createPhotoCard(
      memberId: collectionId,
      title: title,
      album: album,
      version: version,
      benefitSource: benefitSource,
      acquiredAt: acquiredAt,
      price: price,
      memo: memo,
    );
    state = state.copyWith(cards: [...state.cards, card]);
    _save();
  }

  void updateCardRecord({
    required String cardId,
    required String album,
    required String version,
    required String benefitSource,
    required DateTime acquiredAt,
    required String price,
    required String memo,
  }) {
    state = state.copyWith(
      cards: state.cards
          .map((card) => card.id == cardId
              ? card.copyWith(
                  album: album,
                  version: version,
                  benefitSource: benefitSource,
                  acquiredAt: acquiredAt,
                  price: price,
                  memo: memo,
                )
              : card)
          .toList(),
    );
    _save();
  }

  void decorateBinder({
    required String binderId,
    String? coverImagePath,
    required bool clearCoverImage,
    required String coverTitle,
    required String coverSubtitle,
    required String themeId,
    required List<String> stickerIds,
  }) {
    state = state.copyWith(
      binders: state.binders
          .map(
            (binder) => binder.id == binderId
                ? binder.copyWith(
                    coverImagePath: coverImagePath,
                    clearCoverImage: clearCoverImage,
                    coverTitle: coverTitle,
                    coverSubtitle: coverSubtitle,
                    themeId: themeId,
                    stickerIds: stickerIds,
                  )
                : binder,
          )
          .toList(),
    );
    _save();
  }

  void registerCardPhoto({required String cardId, required String imagePath}) {
    state = state.copyWith(
      cards: state.cards
          .map(
            (card) =>
                card.id == cardId ? card.copyWith(imagePath: imagePath) : card,
          )
          .toList(),
    );
    _save();
  }

  Future<void> deleteCard(PhotoCard card) async {
    state = state.copyWith(
      cards: state.cards
          .map(
            (item) =>
                item.id == card.id ? item.copyWith(clearImage: true) : item,
          )
          .toList(),
    );
    _save();
    await _deleteImage(card);
  }

  Future<void> deleteBinder(MemberBinder binder) async {
    final cardsToDelete = state.cards
        .where((card) => card.memberId == binder.id)
        .toList();
    state = state.copyWith(
      binders: state.binders.where((item) => item.id != binder.id).toList(),
      cards: state.cards.where((card) => card.memberId != binder.id).toList(),
      selectedBinderId: null,
    );
    _save();
    await Future.wait(cardsToDelete.map(_deleteImage));
  }

  void openBinder(String id) => state = state.copyWith(selectedBinderId: id);
  void closeBinder() => state = state.copyWith(selectedBinderId: null);
  void setSaving(bool value) => state = state.copyWith(isSaving: value);
  void selectTab(int value) => state = state.copyWith(tab: value);

  Future<void> _restore() async {
    final saved = await _repository.load();
    final groupIds = saved.groupIds.isNotEmpty
        ? saved.groupIds
        : [
            if (saved.binders.any((binder) => binder.id == 'rescene_re_scene'))
              'rescene',
          ];
    state = state.copyWith(
      binders: saved.binders,
      cards: saved.cards,
      groupIds: groupIds,
    );
    if (saved.groupIds.isEmpty && groupIds.isNotEmpty) _save();
  }

  void _save() => Future<void>.microtask(
    () => _repository.save(
      BinderCollection(
        binders: state.binders,
        cards: state.cards,
        groupIds: state.groupIds,
      ),
    ),
  );

  Future<void> _deleteImage(PhotoCard card) async {
    try {
      final path = card.imagePath;
      if (path != null) {
        final image = File(path);
        if (await image.exists()) await image.delete();
      }
    } on FileSystemException {
      // Storage cleanup must not prevent removing the saved card entry.
    }
  }
}
