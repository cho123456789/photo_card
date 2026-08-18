import '../entities/photo_card.dart';

class UpdatePhotoCardRecord {
  const UpdatePhotoCardRecord();

  List<PhotoCard> call({
    required List<PhotoCard> cards,
    required String cardId,
    required String album,
    required String version,
    required String benefitSource,
    required DateTime acquiredAt,
    required String price,
    required String memo,
  }) =>
      cards
          .map(
            (card) => card.id == cardId
                ? card.copyWith(
                    album: album,
                    version: version,
                    benefitSource: benefitSource,
                    acquiredAt: acquiredAt,
                    price: price,
                    memo: memo,
                  )
                : card,
          )
          .toList();
}
