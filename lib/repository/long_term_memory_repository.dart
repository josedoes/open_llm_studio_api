import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';

import '../model/long_term_memory.dart';
import '../service/long_term_memory_service.dart';
import '../utils/logging.dart';

LongTermMemoryRepository get longTermMemoryRepository =>
    GetIt.instance<LongTermMemoryRepository>();

class LongTermMemoryRepository {
  final tag = 'LongTermMemoryRepository';
  final modelCache = <String, LongtermMemory>{};

  Future<Either<String, LongtermMemory>> create(
      {required LongtermMemory model}) async {
    devLog(tag: tag, message: 'create');
    try {
      final result = await longTermMemoryService.set(model: model);
      if (result.isRight) {
        devLog(tag: tag, message: 'create adding to cache');
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, LongtermMemory>> update(
      {required LongtermMemory model}) async {
    try {
      devLog(tag: tag, message: 'update');
      final result = await longTermMemoryService.set(model: model);
      if (result.isRight) {
        modelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, String>> delete({required LongtermMemory model}) async {
    try {
      devLog(tag: tag, message: 'delete');
      final result = await longTermMemoryService.delete(id: model.id ?? '');
      if (result.isRight) {
        modelCache.remove(result.right ?? '');
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }
}
