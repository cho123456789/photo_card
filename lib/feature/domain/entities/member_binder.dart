/// 한 멤버에게 연결된 전용 포토카드 바인더를 표현하는 도메인 객체입니다.
///
/// Flutter 색상 객체를 직접 갖지 않고 색상 정수만 보관해 UI와 도메인을 분리합니다.
class MemberBinder {
  const MemberBinder({
    required this.id,
    required this.name,
    required this.group,
    required this.colorValue,
    this.coverImagePath,
    this.coverTitle,
    this.coverSubtitle,
    this.themeId = 'glitter',
  });

  /// 저장·조회에 사용하는 고유 키입니다.
  final String id;
  /// 바인더 주인인 멤버의 표시 이름입니다.
  final String name;
  /// 아이돌 그룹 등 보조 표시 정보입니다.
  final String group;
  /// UI에서 색상 객체로 변환할 ARGB 색상값입니다.
  final int colorValue;
  final String? coverImagePath;
  final String? coverTitle;
  final String? coverSubtitle;
  final String themeId;

  MemberBinder copyWith({
    String? name,
    String? coverImagePath,
    bool clearCoverImage = false,
    String? coverTitle,
    String? coverSubtitle,
    String? themeId,
  }) => MemberBinder(
    id: id,
    name: name ?? this.name,
    group: group,
    colorValue: colorValue,
    coverImagePath: clearCoverImage ? null : (coverImagePath ?? this.coverImagePath),
    coverTitle: coverTitle ?? this.coverTitle,
    coverSubtitle: coverSubtitle ?? this.coverSubtitle,
    themeId: themeId ?? this.themeId,
  );
}
