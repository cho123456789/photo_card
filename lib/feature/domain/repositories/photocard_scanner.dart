/// 실제 카메라/ML 구현을 숨기는 스캐너 계약입니다.
abstract interface class PhotocardScanner {
  /// 보정된 이미지를 영구 위치에 저장한 경로를 반환합니다.
  /// 사용자가 촬영을 취소하면 `null`을 반환합니다.
  Future<String?> scanAndStore();
}
