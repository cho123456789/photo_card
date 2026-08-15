/// A collectible photocard slot inside an album or collaboration collection.
class PhotoCard {
  const PhotoCard({
    required this.id,
    required this.memberId,
    required this.title,
    this.imagePath,
    this.album = '',
    this.version = '',
    this.benefitSource = '',
    this.acquiredAt,
    this.price = '',
    this.memo = '',
    required this.createdAt,
  });

  final String id;

  /// The collection ID this slot belongs to.
  final String memberId;

  /// Example: '원이 · 셀피 포토카드 A Ver.1'.
  final String title;

  /// null means the card is not owned yet.
  final String? imagePath;
  final String album;
  final String version;
  final String benefitSource;
  final DateTime? acquiredAt;
  final String price;
  final String memo;
  final DateTime createdAt;

  bool get isOwned => imagePath != null;

  PhotoCard copyWith({
    String? imagePath,
    bool clearImage = false,
    String? album,
    String? version,
    String? benefitSource,
    DateTime? acquiredAt,
    bool clearAcquiredAt = false,
    String? price,
    String? memo,
  }) => PhotoCard(
    id: id,
    memberId: memberId,
    title: title,
    imagePath: clearImage ? null : (imagePath ?? this.imagePath),
    album: album ?? this.album,
    version: version ?? this.version,
    benefitSource: benefitSource ?? this.benefitSource,
    acquiredAt: clearAcquiredAt ? null : (acquiredAt ?? this.acquiredAt),
    price: price ?? this.price,
    memo: memo ?? this.memo,
    createdAt: createdAt,
  );
}
