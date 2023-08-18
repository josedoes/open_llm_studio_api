import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import '../model/llm_space.dart';
import '../service/llm_space_service.dart';
import '../utils/logging.dart';

LlmSpaceRepository get llmSpaceRepository => GetIt.instance<LlmSpaceRepository>();

class LlmSpaceRepository {
  final tag = 'LlmSpaceRepository';
  final llmSpaceCache = <String, LlmSpace>{};

  Future<Either<String, LlmSpace>> create({required LlmSpace model}) async {
    devLog(tag: tag, message: 'create');
    try {
      final result = await llmSpaceService.set(model: model);
      if (result.isRight) {
        devLog(tag: tag, message: 'create adding to cache');
        llmSpaceCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, LlmSpace?>> read({required String id}) async {
    devLog(tag: tag, message: 'read');
    final cache = llmSpaceCache[id];

    if (cache != null) {
      devLog(tag: tag, message: 'read loading from cache');
      return Right(cache);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await llmSpaceService.read(id: id);
      if (result.isRight) {
        if (result.right != null) {
          devLog(tag: tag, message: 'read adding result to cache');
          llmSpaceCache[id] = result.right!;
        }
      }
      return result;
    }
  }

  Future<Either<String, LlmSpace>> update({required LlmSpace model}) async {
    try {
      devLog(tag: tag, message: 'update');
      final result = await llmSpaceService.set(model: model);
      if (result.isRight) {
        llmSpaceCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, LlmSpace?>> delete({required LlmSpace model}) async {
    try {
      devLog(tag: tag, message: 'delete');
      final result = await llmSpaceService.delete(model: model);
      if (result.isRight) {
        llmSpaceCache.remove(result.right.id ?? '');
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, List<LlmSpace>>> readAll() async {
    devLog(tag: tag, message: 'readAll');

    final cacheList = llmSpaceCache.values.toList();

    if (cacheList.isNotEmpty) {
      devLog(
          tag: tag,
          message: 'readAll loading from cache length${cacheList.length}');
      return Right(cacheList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await llmSpaceService.readAll();
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          llmSpaceCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }

  Future<Either<String, List<LlmSpace>>> query(Map<String, dynamic> query) async {
    devLog(tag: tag, message: 'query');

    final cachedList = llmSpaceCache.values.where((e) => e.match(query)).toList();

    if (cachedList.isNotEmpty) {
      devLog(
        tag: tag,
        message: 'query loading from cache length${cachedList.length}',
      );
      return Right(cachedList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await llmSpaceService.queryContains(query);
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          llmSpaceCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }
}
