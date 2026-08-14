import '../entities/member_binder.dart';

/// 새 멤버 바인더를 만들 때 필요한 기본값을 한곳에 모은 유스케이스입니다.
class CreateMemberBinder {
  const CreateMemberBinder();

  // call는 객체를 함수로 호출 가능
  /// 현재 시간을 이용해 중복 가능성이 낮은 ID를 만들고 엔티티를 반환합니다.
  MemberBinder call({required String name, required String group, required int colorValue}) => MemberBinder(
    id: 'member_${DateTime.now().microsecondsSinceEpoch}',
    name: name,
    group: group,
    colorValue: colorValue,
  );
}
