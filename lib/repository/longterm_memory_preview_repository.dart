import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';

import '../model/long_term_memory.dart';
import '../service/memory_preview_service.dart';
import '../util/logging.dart';

MemoryPreviewRepository get memoryPreviewRepository =>
    GetIt.instance<MemoryPreviewRepository>();

class MemoryPreviewRepository {
  final tag = 'MemoryPreviewRepository';
  final modelCache = <String, MemoryPreview>{};

  Future<Either<String, MemoryPreview>> create(
      {required MemoryPreview model}) async {
    devLog(tag: tag, message: 'create');
    try {
      final result = await memoryPreviewService.set(model: model);
      if (result.isRight) {
        devLog(tag: tag, message: 'create adding to cache');
        modelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, MemoryPreview?>> read({required String id}) async {
    devLog(tag: tag, message: 'read');
    final cache = modelCache[id];

    if (cache != null) {
      devLog(tag: tag, message: 'read loading from cache');
      return Right(cache);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await memoryPreviewService.read(id: id);
      if (result.isRight) {
        if (result.right != null) {
          devLog(tag: tag, message: 'read adding result to cache');
          modelCache[id] = result.right ??
              MemoryPreview.fromJson(MemoryPreview.exampleJson());
        }
      }
      return result;
    }
  }

  Future<Either<String, MemoryPreview>> update(
      {required MemoryPreview model}) async {
    try {
      devLog(tag: tag, message: 'update');
      final result = await memoryPreviewService.set(model: model);
      if (result.isRight) {
        modelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, String?>> delete({required MemoryPreview model}) async {
    try {
      devLog(tag: tag, message: 'delete');
      final result = await memoryPreviewService.delete(id: model.id ?? '');
      if (result.isRight) {
        modelCache.remove(model.id);
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, List<MemoryPreview>>> readAll() async {
    devLog(tag: tag, message: 'readAll');
    final cacheList = modelCache.values.toList();

    if (cacheList.isNotEmpty) {
      devLog(
          tag: tag,
          message: 'readAll loading from cache length${cacheList.length}');
      return Right(cacheList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await memoryPreviewService.readAll();
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          modelCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }

// Future<Either<String, List<MemoryPreview>>> query(Map<String, dynamic> query) async {
//   devLog(tag: tag, message: 'query');
//   final cachedList = modelCache.values.where((e) => e.match(query)).toList();
//
//   if (cachedList.isNotEmpty) {
//     devLog(tag: tag, message: 'query loading from cache length${cachedList.length}');
//     return Right(cachedList);
//   } else {
//     devLog(tag: tag, message: 'read loading from service');
//     final result = await memoryPreviewService.queryContains(query);
//     if (result.isRight) {
//       devLog(tag: tag, message: 'read adding result to cache');
//       for (final element in result.right) {
//         modelCache[element.id ?? ''] = element;
//       }
//     }
//     return result;
//   }
// }
}
