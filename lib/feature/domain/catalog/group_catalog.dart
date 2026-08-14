import '../entities/binder_collection.dart';
import '../entities/member_binder.dart';
import '../entities/photo_card.dart';

class GroupCatalog {
  const GroupCatalog({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.buildCollection,
  });

  final String id;
  final String name;
  final int colorValue;
  final BinderCollection Function() buildCollection;

  static const available = <GroupCatalog>[rescene];

  static const rescene = GroupCatalog(
    id: 'rescene',
    name: 'RESCENE',
    colorValue: 0xffef8cac,
    buildCollection: _resceneCollection,
  );
}

BinderCollection _resceneCollection() {
  const collectionId = 'rescene_re_scene';
  const members = ['원이', '리브', '미나미', '메이', '제나'];
  return BinderCollection(
    binders: const [
      MemberBinder(
        id: collectionId,
        name: 'Re:Scene',
        group: 'RESCENE · 싱글 1집',
        colorValue: 0xffef8cac,
      ),
    ],
    cards: [
      for (final version in [1, 2])
        for (final member in members)
          PhotoCard(
            id: 're_scene_a_v${version}_${members.indexOf(member)}',
            memberId: collectionId,
            title: '$member · 셀피 포토카드 A Ver.$version',
            createdAt: DateTime(2024, 3, 26),
          ),
    ],
  );
}
