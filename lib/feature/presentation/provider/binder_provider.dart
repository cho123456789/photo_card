import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/repositories/sqflite_binder_repository.dart';
import '../../domain/entities/binder_collection.dart';
import '../../domain/entities/member_binder.dart';
import '../../domain/entities/photo_card.dart';
import '../../domain/repositories/binder_repository.dart';
import '../../domain/usecases/decorate_binder.dart';
import '../../domain/usecases/delete_binder.dart';
import '../../domain/usecases/delete_photo_card.dart';
import '../../domain/usecases/create_member_binder.dart';
import '../../domain/usecases/create_photo_card.dart';
import '../../domain/usecases/load_binder_collection.dart';
import '../../domain/usecases/register_card_photo.dart';
import '../../domain/usecases/save_binder_collection.dart';
import '../../domain/usecases/update_photo_card_record.dart';

part 'binder_provider.freezed.dart';

final binderRepositoryProvider = Provider<BinderRepository>(
  (ref) => SqfliteBinderRepository(),
);

@freezed
abstract class BinderState with _$BinderState {
  const factory BinderState({
    required List<MemberBinder> binders,
    required List<PhotoCard> cards,
    String? selectedBinderId,
    @Default(false) bool isSaving,
    @Default(0) int tab,
  }) = _BinderState;
}

final binderProvider = NotifierProvider<BinderNotifier, BinderState>(
  BinderNotifier.new,
);


// binderState = 상태 데이터
// binderNotifier = 상태를 변경하는 관리자
// binderProvider 를 watch 하고있는 UI 갱신

class BinderNotifier extends Notifier<BinderState> {
  static const _colors = [
    0xffef8cac,
    0xff8094f5,
    0xffe4b365,
    0xff69b9a8,
    0xffa98ae8,
  ];
  late final LoadBinderCollection _loadBinderCollection;
  late final SaveBinderCollection _saveBinderCollection;
  final _createMemberBinder = const CreateMemberBinder();
  final _createPhotoCard = const CreatePhotoCard();
  final _updatePhotoCardRecord = const UpdatePhotoCardRecord();
  final _decorateBinder = const DecorateBinder();
  final _registerCardPhoto = const RegisterCardPhoto();
  final _deletePhotoCard = const DeletePhotoCard();
  final _deleteBinder = const DeleteBinder();

  @override
  BinderState build() {
    final repository = ref.read(binderRepositoryProvider);
    _loadBinderCollection = LoadBinderCollection(repository);
    _saveBinderCollection = SaveBinderCollection(repository);
    Future<void>.microtask(_restore);
    return const BinderState(binders: [], cards: []);
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

  PhotoCard addCard({
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
    return card;
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
      cards: _updatePhotoCardRecord(
        cards: state.cards,
        cardId: cardId,
        album: album,
        version: version,
        benefitSource: benefitSource,
        acquiredAt: acquiredAt,
        price: price,
        memo: memo,
      ),
    );
    _save();
  }

  void renameBinder({required String binderId, required String name}) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;
    state = state.copyWith(
      binders: state.binders
          .map((binder) => binder.id == binderId
              ? binder.copyWith(name: trimmedName)
              : binder)
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
  }) {
    state = state.copyWith(
      binders: _decorateBinder(
        binders: state.binders,
        binderId: binderId,
        coverImagePath: coverImagePath,
        clearCoverImage: clearCoverImage,
        coverTitle: coverTitle,
        coverSubtitle: coverSubtitle,
        themeId: themeId,
      ),
    );
    _save();
  }

  void registerCardPhoto({required String cardId, required String imagePath}) {
    state = state.copyWith(
      cards: _registerCardPhoto(
        cards: state.cards,
        cardId: cardId,
        imagePath: imagePath,
      ),
    );
    _save();
  }

  Future<void> deleteCard(PhotoCard card) async {
    final result = await _deletePhotoCard(
      cards: state.cards,
      card: card,
    );
    state = state.copyWith(cards: result.cards);
    _save();
  }

  Future<void> deleteBinder(MemberBinder binder) async {
    final result = await _deleteBinder(
      binders: state.binders,
      cards: state.cards,
      binder: binder,
    );
    state = state.copyWith(
      binders: result.binders,
      cards: result.cards,
      selectedBinderId: null,
    );
    _save();
  }

  void openBinder(String id) => state = state.copyWith(selectedBinderId: id);
  void closeBinder() => state = state.copyWith(selectedBinderId: null);
  void setSaving(bool value) => state = state.copyWith(isSaving: value);
  void selectTab(int value) => state = state.copyWith(tab: value);

  Future<void> _restore() async {
    final saved = await _loadBinderCollection();
    state = state.copyWith(
      binders: saved.binders,
      cards: saved.cards,
    );
  }

  void _save() => Future<void>.microtask(
    () => _saveBinderCollection(
      BinderCollection(
        binders: state.binders,
        cards: state.cards,
      ),
    ),
  );
}
