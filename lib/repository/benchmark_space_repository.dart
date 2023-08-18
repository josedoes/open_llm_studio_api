import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import '../model/benchmark_space.dart';
import '../service/benchmark_space_service.dart';
import '../utils/logging.dart';

BenchmarkSpaceRepository get benchmarkSpaceRepository =>
    GetIt.instance<BenchmarkSpaceRepository>();

class BenchmarkSpaceRepository {
  final tag = 'BenchmarkSpaceRepository';
  final modelCache = <String, BenchmarkSpaceOld>{};

  Future<Either<String, BenchmarkSpaceOld>> create(
      {required BenchmarkSpaceOld model}) async {
    devLog(tag: tag, message: 'create');
    try {
      final result = await benchmarkSpaceService.set(model: model);
      if (result.isRight) {
        devLog(tag: tag, message: 'create adding to cache');
        modelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, BenchmarkSpaceOld?>> read({required String id}) async {
    devLog(tag: tag, message: 'read');
    final cache = modelCache[id];

    if (cache != null) {
      devLog(tag: tag, message: 'read loading from cache');
      return Right(cache);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await benchmarkSpaceService.read(id: id);
      if (result.isRight) {
        if (result.right != null) {
          devLog(tag: tag, message: 'read adding result to cache');
          modelCache[id] = result.right!;
        }
      }
      return result;
    }
  }

  Future<Either<String, BenchmarkSpaceOld>> update(
      {required BenchmarkSpaceOld model}) async {
    try {
      devLog(tag: tag, message: 'update');
      final result = await benchmarkSpaceService.set(model: model);
      if (result.isRight) {
        modelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, BenchmarkSpaceOld?>> delete(
      {required BenchmarkSpaceOld model}) async {
    try {
      devLog(tag: tag, message: 'delete');
      final result = await benchmarkSpaceService.delete(model: model);
      if (result.isRight) {
        modelCache.remove(result.right.id ?? '');
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, List<BenchmarkSpaceOld>>> readAll() async {
    devLog(tag: tag, message: 'readAll');

    final cacheList = modelCache.values.toList();

    if (cacheList.isNotEmpty) {
      devLog(
          tag: tag,
          message: 'readAll loading from cache length${cacheList.length}');
      return Right(cacheList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await benchmarkSpaceService.readAll();
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          modelCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }
}
