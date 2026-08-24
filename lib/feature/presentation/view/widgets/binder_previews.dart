import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../domain/entities/member_binder.dart';
import '../../../domain/entities/photo_card.dart';
import 'binder_detail.dart';
import 'binder_home.dart';

/// Flutter Widget Previewer가 찾는 바인더 화면 프리뷰 모음입니다.
///
/// 이 파일은 앱 실행 경로에 포함되지 않습니다. `@Preview`가 붙은 공개 함수만
/// `flutter widget-preview start` 또는 IDE의 Flutter Widget Preview 탭에 표시됩니다.

@Preview(name: '빈 바인더 안내', group: '바인더 홈', size: Size(390, 844))
Widget previewEmptyBinderHome() => _PreviewApp(
  child: const BinderHome(
    binders: [],
    cards: [],
    onOpen: previewIgnoreOpen,
    onCreate: previewIgnoreCreate,
    onDelete: previewIgnoreDeleteMemberBinder,
    onRename: previewIgnoreRename,
  ),
);

@Preview(name: '멤버 바인더 목록', group: '바인더 홈', size: Size(390, 844))
Widget previewBinderHomeWithMembers() => _PreviewApp(
  child: BinderHome(
    binders: _previewBinders,
    cards: _previewCards,
    onOpen: previewIgnoreOpen,
    onCreate: previewIgnoreCreate,
    onDelete: previewIgnoreDeleteMemberBinder,
    onRename: previewIgnoreRename,
  ),
);

@Preview(name: '카드 없음', group: '바인더 상세', size: Size(390, 844))
Widget previewEmptyBinderDetail() => _PreviewApp(
  child: BinderDetail(
    binder: _previewHanni,
    cards: const [],
    onDelete: previewIgnoreDelete,
    onDeleteBinder: previewIgnoreDeleteBinder,
    onAddCard: previewIgnoreAddCard,
    onDecorate: previewIgnoreCreate,
    onRecord: previewIgnoreRecord,
    onRegisterCard: previewIgnoreRegister, onRenameBinder: (String value) {  },
  ),
);

@Preview(name: '카드가 있는 바인더 상세', group: '바인더 상세', size: Size(390, 844))
Widget previewBinderDetailWithCards() => _PreviewApp(
  child: BinderDetail(
    binder: _previewHanni,
    cards: [_previewCards.first],
    onDelete: previewIgnoreDelete,
    onDeleteBinder: previewIgnoreDeleteBinder,
    onAddCard: previewIgnoreAddCard,
    onDecorate: previewIgnoreCreate,
    onRecord: previewIgnoreRecord,
    onRegisterCard: previewIgnoreRegister, onRenameBinder: (String value) {  },
  ),
);

/// 프리뷰에서는 실제 화면 전환이나 다이얼로그를 열지 않으므로 빈 콜백을 전달합니다.
/// `@Preview`에 전달하는 콜백은 공개 top-level 함수여야 합니다.
void previewIgnoreOpen(String _) {}
void previewIgnoreCreate() {}
void previewIgnoreRename(MemberBinder _, String __) {}
void previewIgnoreAddCard(String? _) {}
Future<void> previewIgnoreDelete(PhotoCard _) async {}
Future<void> previewIgnoreDeleteBinder() async {}
Future<void> previewIgnoreDeleteMemberBinder(MemberBinder _) async {}
void previewIgnoreRecord(PhotoCard _) {}
Future<void> previewIgnoreRegister(PhotoCard _) async {}

/// 프리뷰에서도 앱과 같은 Material 테마·Scaffold 환경을 제공합니다.
class _PreviewApp extends StatelessWidget {
  const _PreviewApp({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff7c5cff),
        brightness: Brightness.dark,
      ),
    ),
    home: Scaffold(body: child),
  );
}

const _previewHanni = MemberBinder(
  id: 'preview_hanni',
  name: 'Hanni',
  group: 'NewJeans',
  colorValue: 0xffef8cac,
);

const _previewMinji = MemberBinder(
  id: 'preview_minji',
  name: 'Minji',
  group: 'NewJeans',
  colorValue: 0xff8094f5,
);

const _previewBinders = [_previewHanni, _previewMinji];

final _previewCards = [
  PhotoCard(
    id: 'preview_card_1',
    memberId: _previewHanni.id,
    title: '하니 · Preview',
    imagePath: 'preview-only.jpg',
    createdAt: DateTime(2026, 8, 1),
  ),
  PhotoCard(
    id: 'preview_card_2',
    memberId: _previewMinji.id,
    title: '민지 · Preview',
    imagePath: 'preview-only.jpg',
    createdAt: DateTime(2026, 8, 2),
  ),
];
