import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../domain/entities/binder_collection.dart';
import '../../domain/entities/member_binder.dart';
import '../../domain/entities/photo_card.dart';
import '../../domain/repositories/binder_repository.dart';

/// 앱 문서 저장소의 JSON 파일에 바인더 목록을 저장하는 구현체입니다.
class LocalBinderRepository implements BinderRepository {
  /// 예전 데이터에 색상값이 없을 때 적용할 기본 팔레트입니다.
  static const _legacyColors = <int>[
    0xffef8cac,
    0xff8094f5,
    0xffe4b365,
    0xff69b9a8,
    0xffa98ae8,
  ];

  @override
  Future<BinderCollection> load() async {
    try {
      // 앱 전용 JSON 파일이 없으면 최초 실행으로 보고 빈 컬렉션을 반환합니다.
      final file = await _indexFile();
      if (!await file.exists()) {
        return const BinderCollection(binders: [], cards: []);
      }
      final index =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      // JSON(Map) 데이터를 도메인 엔티티로 역직렬화합니다.
      final binderData = index['binders'] as List<dynamic>;
      final binders = <MemberBinder>[];
      for (var i = 0; i < binderData.length; i++) {
        final data = binderData[i] as Map<String, dynamic>;
        binders.add(
          MemberBinder(
            id: data['id'] as String,
            name: data['name'] as String,
            group: data['group'] as String,
            colorValue:
                (data['colorValue'] as int?) ??
                _legacyColors[i % _legacyColors.length],
            coverImagePath: data['coverImagePath'] as String?,
            coverTitle: data['coverTitle'] as String?,
            coverSubtitle: data['coverSubtitle'] as String?,
            themeId: (data['themeId'] as String?) ?? 'glitter',
            stickerIds: (data['stickerIds'] as List<dynamic>? ?? [])
                .cast<String>(),
          ),
        );
      }
      // 카드도 UI와 무관한 PhotoCard 엔티티로 복원합니다.
      final cards = (index['cards'] as List<dynamic>).map((raw) {
        final data = raw as Map<String, dynamic>;
        return PhotoCard(
          id: data['id'] as String,
          memberId: data['memberId'] as String,
          title: (data['title'] as String?) ?? '등록한 포토카드',
          imagePath: data['imagePath'] as String?,
          album: (data['album'] as String?) ?? '',
          version: (data['version'] as String?) ?? '',
          benefitSource: (data['benefitSource'] as String?) ?? '',
          acquiredAt: data['acquiredAt'] == null
              ? null
              : DateTime.parse(data['acquiredAt'] as String),
          price: (data['price'] as String?) ?? '',
          memo: (data['memo'] as String?) ?? '',
          createdAt: DateTime.parse(data['createdAt'] as String),
        );
      }).toList();
      return BinderCollection(
        binders: binders,
        cards: cards,
        groupIds: (index['groupIds'] as List<dynamic>? ?? []).cast<String>(),
      );
    } catch (_) {
      // 손상된 파일 때문에 앱 실행이 막히지 않도록 빈 상태로 복구합니다.
      return const BinderCollection(binders: [], cards: []);
    }
  }

  @override
  Future<void> save(BinderCollection collection) async {
    // 엔티티를 JSON으로 바꿔 한 파일에 저장합니다.
    final file = await _indexFile();
    await file.writeAsString(
      jsonEncode({
        'groupIds': collection.groupIds,
        'binders': collection.binders
            .map(
              (binder) => {
                'id': binder.id,
                'name': binder.name,
                'group': binder.group,
                'colorValue': binder.colorValue,
                'coverImagePath': binder.coverImagePath,
                'coverTitle': binder.coverTitle,
                'coverSubtitle': binder.coverSubtitle,
                'themeId': binder.themeId,
                'stickerIds': binder.stickerIds,
              },
            )
            .toList(),
        'cards': collection.cards
            .map(
              (card) => {
                'id': card.id,
                'memberId': card.memberId,
                'title': card.title,
                'imagePath': card.imagePath,
                'album': card.album,
                'version': card.version,
                'benefitSource': card.benefitSource,
                'acquiredAt': card.acquiredAt?.toIso8601String(),
                'price': card.price,
                'memo': card.memo,
                'createdAt': card.createdAt.toIso8601String(),
              },
            )
            .toList(),
      }),
    );
  }

  Future<File> _indexFile() async {
    // 캐시가 아닌 앱 문서 폴더를 사용하므로 OS가 임의로 지우지 않습니다.
    final directory = await getApplicationDocumentsDirectory();
    return File(
      '${directory.path}${Platform.pathSeparator}photocard_binder.json',
    );
  }
}
