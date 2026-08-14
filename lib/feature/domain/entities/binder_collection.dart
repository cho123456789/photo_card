import 'member_binder.dart';
import 'photo_card.dart';

/// 로컬 저장소에 한 번에 저장·복원하는 바인더 전체 데이터 묶음입니다.
class BinderCollection {
  const BinderCollection({
    required this.binders,
    required this.cards,
    this.groupIds = const [],
  });

  /// 생성한 멤버별 바인더 목록입니다.
  final List<MemberBinder> binders;

  /// 모든 바인더에 속한 카드 목록입니다.
  final List<PhotoCard> cards;
  final List<String> groupIds;
}
