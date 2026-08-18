import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../domain/entities/binder_collection.dart';
import '../../domain/entities/member_binder.dart';
import '../../domain/entities/photo_card.dart';
import '../../domain/repositories/binder_repository.dart';

class LocalBinderRepository implements BinderRepository {
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
      final file = await _indexFile();
      if (!await file.exists()) {
        return const BinderCollection(binders: [], cards: []);
      }
      final index =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;  // Map
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
          ),
        );
      }
      final cards = (index['cards'] as List<dynamic>).map((raw) {
        final data = raw as Map<String, dynamic>;
        return PhotoCard(
          id: data['id'] as String,
          memberId: data['memberId'] as String,
          title: (data['title'] as String?) ?? '',
          imagePath: data['imagePath'] as String? ,
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
      );
    } catch (_) {
      return const BinderCollection(binders: [], cards: []);
    }
  }

  @override
  Future<void> save(BinderCollection collection) async {
    final file = await _indexFile();
    await file.writeAsString(
      jsonEncode({
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
    final directory = await getApplicationDocumentsDirectory();
    return File(
      '${directory.path}${Platform.pathSeparator}photocard_binder.json',
    );
  }
}
