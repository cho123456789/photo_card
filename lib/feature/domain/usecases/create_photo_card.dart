import '../entities/photo_card.dart';

/// 스캔이 끝난 이미지 경로를 앱에서 사용할 포토카드 엔티티로 바꿉니다.
class CreatePhotoCard {
  const CreatePhotoCard();

  /// 대상 멤버 ID와 보정 이미지 경로를 연결해 새 카드를 만듭니다.
  PhotoCard call({
    required String memberId,
    required String title,
    String? imagePath,
    String album = '',
    String version = '',
    String benefitSource = '',
    DateTime? acquiredAt,
    String price = '',
    String memo = '',
  }) => PhotoCard(
    id: 'card_${DateTime.now().microsecondsSinceEpoch}',
    memberId: memberId,
    imagePath: imagePath,
    title: title,
    album: album,
    version: version,
    benefitSource: benefitSource,
    acquiredAt: acquiredAt,
    price: price,
    memo: memo,
    createdAt: DateTime.now(),
  );
}
