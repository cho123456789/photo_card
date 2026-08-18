import '../entities/photo_card.dart';

class RegisterCardPhoto {
  const RegisterCardPhoto();

  List<PhotoCard> call({
    required List<PhotoCard> cards,
    required String cardId,
    required String imagePath,
  }) =>
      cards
          .map(
            (card) =>
                card.id == cardId ? card.copyWith(imagePath: imagePath) : card,
          )
          .toList();
}
