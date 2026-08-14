import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/repositories/photocard_scanner.dart';

/// 네이티브 ML 문서 스캐너를 포토카드 촬영에 연결한 구현체입니다.
class MlPhotocardScanner implements PhotocardScanner {
  @override
  Future<String?> scanAndStore() async {
    // Android ML Kit/iOS Vision이 모서리 검출과 원근 보정을 처리합니다.
    final scans = await CunningDocumentScanner.getPictures(noOfPages: 1);
    if (scans == null || scans.isEmpty) return null;

    // 플러그인의 임시 캐시는 OS가 삭제할 수 있어 앱 문서 폴더로 복사합니다.
    final documents = await getApplicationDocumentsDirectory();
    final folder = Directory('${documents.path}${Platform.pathSeparator}photocard_binder');
    if (!await folder.exists()) await folder.create(recursive: true);
    // 한 장만 스캔하도록 제한했으므로 첫 결과만 저장합니다.
    final source = File(scans.first);
    final extension = source.path.split('.').last;
    final destination = File('${folder.path}${Platform.pathSeparator}card_${DateTime.now().millisecondsSinceEpoch}.$extension');
    await source.copy(destination.path);
    return destination.path;
  }
}
