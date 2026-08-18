import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/binder_collection.dart';
import '../../domain/entities/member_binder.dart';
import '../../domain/entities/photo_card.dart';
import '../../domain/repositories/binder_repository.dart';

/// SQLite를 사용해 바인더와 포토카드 데이터를 저장하는 repository입니다.
///
/// domain 계층은 [BinderRepository]만 알고 있으므로 저장 방식이 JSON에서
/// SQLite로 변경되어도 usecase와 presentation 계층은 영향을 받지 않습니다.
class SqfliteBinderRepository implements BinderRepository {
  /// 앱 문서 디렉터리에 생성되는 SQLite 데이터베이스 파일명입니다.
  static const _databaseName = 'photocard_binder.db';

  /// 테이블 구조가 변경되면 버전을 올리고 onUpgrade 마이그레이션을 추가합니다.
  static const _databaseVersion = 1;

  // 데이터베이스 연결은 처음 사용될 때 한 번만 엽니다.
  Future<Database>? _database;

  /// 여러 load/save 호출에서 동일한 데이터베이스 연결을 재사용합니다.
  Future<Database> get _db =>
      _database ??= _openDatabase();

  /// 데이터베이스를 열고 최초 스키마를 생성합니다.
  Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    return openDatabase(
      join(databasesPath, _databaseName),
      version: _databaseVersion,
      onConfigure: (database) async {
        // 바인더 삭제 시 연결된 카드도 함께 삭제되도록 외래키를 활성화합니다.
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (database, version) async {
        // 바인더 기본 정보 테이블입니다.
        await database.execute('''
          CREATE TABLE binders (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            group_name TEXT NOT NULL,
            color_value INTEGER NOT NULL,
            cover_image_path TEXT,
            cover_title TEXT,
            cover_subtitle TEXT,
            theme_id TEXT NOT NULL
          )
        ''');
        // 포토카드 테이블입니다. member_id로 바인더와 연결됩니다.
        await database.execute('''
          CREATE TABLE cards (
            id TEXT PRIMARY KEY,
            member_id TEXT NOT NULL,
            title TEXT NOT NULL,
            image_path TEXT,
            album TEXT NOT NULL,
            version TEXT NOT NULL,
            benefit_source TEXT NOT NULL,
            acquired_at TEXT,
            price TEXT NOT NULL,
            memo TEXT NOT NULL,
            created_at TEXT NOT NULL,
            FOREIGN KEY (member_id) REFERENCES binders (id) ON DELETE CASCADE
          )
        ''');
        await database.execute(
          'CREATE INDEX cards_member_id_index ON cards (member_id)',
        );
        // 기존 JSON 저장소가 있으면 최초 생성 시 SQLite로 가져옵니다.
        // await _migrateLegacyJson(database);
      },
    );
  }

  @override
  Future<BinderCollection> load() async {
    final database = await _db;
    // SQLite 행을 domain entity로 변환해 반환합니다.
    final binderRows = await database.query('binders');
    final cardRows = await database.query('cards');

    return BinderCollection(
      binders: binderRows.map(_binderFromRow).toList(),
      cards: cardRows.map(_cardFromRow).toList(),
    );
  }

  @override
  Future<void> save(BinderCollection collection) async {
    final database = await _db;
    // 컬렉션 전체 저장을 하나의 transaction으로 처리해 부분 저장을 방지합니다.
    await database.transaction((transaction) async {
      await transaction.delete('cards');
      await transaction.delete('binders');

      for (final binder in collection.binders) {
        await transaction.insert('binders', _binderToRow(binder));
      }
      for (final card in collection.cards) {
        await transaction.insert('cards', _cardToRow(card));
      }
    });
  }

  MemberBinder _binderFromRow(Map<String, Object?> row) => MemberBinder(
        id: row['id']! as String,
        name: row['name']! as String,
        group: row['group_name']! as String,
        colorValue: row['color_value']! as int,
        coverImagePath: row['cover_image_path'] as String?,
        coverTitle: row['cover_title'] as String?,
        coverSubtitle: row['cover_subtitle'] as String?,
        themeId: row['theme_id']! as String,
      );

  PhotoCard _cardFromRow(Map<String, Object?> row) => PhotoCard(
        id: row['id']! as String,
        memberId: row['member_id']! as String,
        title: row['title']! as String,
        imagePath: row['image_path'] as String?,
        album: row['album']! as String,
        version: row['version']! as String,
        benefitSource: row['benefit_source']! as String,
        acquiredAt: _parseDate(row['acquired_at'] as String?),
        price: row['price']! as String,
        memo: row['memo']! as String,
        createdAt: DateTime.parse(row['created_at']! as String),
      );

  Map<String, Object?> _binderToRow(MemberBinder binder) => {
        'id': binder.id,
        'name': binder.name,
        'group_name': binder.group,
        'color_value': binder.colorValue,
        'cover_image_path': binder.coverImagePath,
        'cover_title': binder.coverTitle,
        'cover_subtitle': binder.coverSubtitle,
        'theme_id': binder.themeId,
      };

  Map<String, Object?> _cardToRow(PhotoCard card) => {
        'id': card.id,
        'member_id': card.memberId,
        'title': card.title,
        'image_path': card.imagePath,
        'album': card.album,
        'version': card.version,
        'benefit_source': card.benefitSource,
        'acquired_at': card.acquiredAt?.toIso8601String(),
        'price': card.price,
        'memo': card.memo,
        'created_at': card.createdAt.toIso8601String(),
      };

  DateTime? _parseDate(String? value) =>
      value == null ? null : DateTime.parse(value);

  // /// 이전 JSON 저장소의 데이터를 SQLite로 한 번만 옮깁니다.
  // /// 원본 JSON 파일은 마이그레이션 실패에 대비해 삭제하지 않습니다.
  // Future<void> _migrateLegacyJson(Database database) async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File(join(directory.path, 'photocard_binder.json'));
  //     if (!await file.exists()) {
  //       return;
  //     }
  //
  //     final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  //     final binders = (json['binders'] as List<dynamic>? ?? const [])
  //         .cast<Map<String, dynamic>>();
  //     final cards = (json['cards'] as List<dynamic>? ?? const [])
  //         .cast<Map<String, dynamic>>();
  //
  //     await database.transaction((transaction) async {
  //       for (final binder in binders) {
  //         await transaction.insert('binders', {
  //           'id': binder['id'],
  //           'name': binder['name'],
  //           'group_name': binder['group'],
  //           'color_value': binder['colorValue'],
  //           'cover_image_path': binder['coverImagePath'],
  //           'cover_title': binder['coverTitle'],
  //           'cover_subtitle': binder['coverSubtitle'],
  //           'theme_id': binder['themeId'] ?? 'glitter',
  //         });
  //       }
  //       for (final card in cards) {
  //         await transaction.insert('cards', {
  //           'id': card['id'],
  //           'member_id': card['memberId'],
  //           'title': card['title'] ?? '',
  //           'image_path': card['imagePath'],
  //           'album': card['album'] ?? '',
  //           'version': card['version'] ?? '',
  //           'benefit_source': card['benefitSource'] ?? '',
  //           'acquired_at': card['acquiredAt'],
  //           'price': card['price'] ?? '',
  //           'memo': card['memo'] ?? '',
  //           'created_at': card['createdAt'],
  //         });
  //       }
  //     });
  //   } catch (_) {
  //     // A failed migration must not prevent creating a usable database.
  //   }
  // }
}
