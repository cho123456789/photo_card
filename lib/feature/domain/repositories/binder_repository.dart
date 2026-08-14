import '../entities/binder_collection.dart';

/// 바인더 데이터를 어디에 저장할지와 무관하게 사용하는 도메인 계약입니다.
///
/// 현재는 JSON 파일 구현체를 쓰지만, 이후 SQLite·Supabase 구현체로 교체할 수 있습니다.
abstract interface class BinderRepository {
  /// 저장된 전체 바인더 데이터를 읽습니다.
  Future<BinderCollection> load();
  /// 최신 전체 바인더 데이터를 저장합니다.
  Future<void> save(BinderCollection collection);
}
