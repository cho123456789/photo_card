import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feature/presentation/view/photocard_binder_page.dart';

/// Riverpod 상태 컨테이너를 최상단에 두고 앱을 시작합니다.
void main() => runApp(const ProviderScope(child: PhotocardBinderApp()));

/// 앱 전체 테마와 첫 화면을 설정합니다.
class PhotocardBinderApp extends StatelessWidget {
  const PhotocardBinderApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Pocket Binder',
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff7c5cff), brightness: Brightness.dark)),
    home: const PhotocardBinderPage(),
  );
}
