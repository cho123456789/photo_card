import 'dart:io';

import '../entities/member_binder.dart';
import '../entities/photo_card.dart';

class DeleteBinderResult {
  const DeleteBinderResult({
    required this.binders,
    required this.cards,
  });

  final List<MemberBinder> binders;
  final List<PhotoCard> cards;
}

class DeleteBinder {
  const DeleteBinder();

  Future<DeleteBinderResult> call({
    required List<MemberBinder> binders,
    required List<PhotoCard> cards,
    required MemberBinder binder,
  }) async {
    final cardsToDelete = cards.where((card) => card.memberId == binder.id).toList();
    await Future.wait(cardsToDelete.map((card) => _deleteFile(card.imagePath)));
    await _deleteFile(binder.coverImagePath);

    return DeleteBinderResult(
      binders: binders.where((item) => item.id != binder.id).toList(),
      cards: cards.where((card) => card.memberId != binder.id).toList(),
    );
  }

  Future<void> _deleteFile(String? path) async {
    if (path == null) {
      return;
    }
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } on FileSystemException {
      // File cleanup must not block deletion of binder data.
    }
  }
}
