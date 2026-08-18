import '../entities/binder_collection.dart';
import '../repositories/binder_repository.dart';

/// 현재 바인더 컬렉션을 저장하는 usecase입니다.
class SaveBinderCollection {
  const SaveBinderCollection(this._repository);

  final BinderRepository _repository;

  Future<void> call(BinderCollection collection) => _repository.save(collection);
}
