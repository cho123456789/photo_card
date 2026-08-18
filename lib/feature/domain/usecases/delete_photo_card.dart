import 'dart:io';

import '../entities/photo_card.dart';

class DeletePhotoCardResult {
  const DeletePhotoCardResult({required this.cards});

  final List<PhotoCard> cards;
}

class DeletePhotoCard {
  const DeletePhotoCard();

  Future<DeletePhotoCardResult> call({
    required List<PhotoCard> cards,
    required PhotoCard card,
  }) async {
    await _deleteFile(card.imagePath);
    return DeletePhotoCardResult(
      cards: cards.where((item) => item.id != card.id).toList(),
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
      // File cleanup must not block deletion of the card record.
    }
  }
}
