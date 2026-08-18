import '../entities/binder_collection.dart';
import '../repositories/binder_repository.dart';

/// 저장된 바인더 컬렉션을 불러오는 usecase입니다.
class LoadBinderCollection {
  const LoadBinderCollection(this._repository);

  final BinderRepository _repository;

  Future<BinderCollection> call() => _repository.load();
}
