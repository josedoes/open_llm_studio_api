import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import '../model/agent.dart';
import '../service/agent_service.dart';
import '../utils/logging.dart';

AgentRepository get agentRepository => GetIt.instance<AgentRepository>();

class AgentRepository {
  final tag = 'AgentRepository';
  final agentCache = <String, Agent>{};

  Future<Either<String, Agent>> create({required Agent model}) async {
    devLog(tag: tag, message: 'create');
    try {
      final result = await agentService.set(model: model);
      if (result.isRight) {
        devLog(tag: tag, message: 'create adding to cache');
        agentCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      devLog(tag: tag, message: 'ERROR $e');
      return Left('Error');
    }
  }

  Future<Either<String, Agent?>> read({required String id}) async {
    devLog(tag: tag, message: 'read');
    final cache = agentCache[id];

    if (cache != null) {
      devLog(tag: tag, message: 'read loading from cache');
      return Right(cache);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await agentService.read(id: id);
      if (result.isRight) {
        if (result.right != null) {
          devLog(tag: tag, message: 'read adding result to cache');
          agentCache[id] = result.right!;
        }
      }
      return result;
    }
  }

  Future<Either<String, Agent>> update({required Agent model}) async {
    try {
      devLog(tag: tag, message: 'update');
      final result = await agentService.set(model: model);
      if (result.isRight) {
        agentCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      devLog(tag: tag, message: 'ERROR $e');
      return Left('Error');
    }
  }

  Future<Either<String, Agent?>> delete({required Agent model}) async {
    try {
      devLog(tag: tag, message: 'delete');
      final result = await agentService.delete(model: model);
      if (result.isRight) {
        agentCache.remove(result.right.id ?? '');
      }
      return result;
    } catch (e) {
      devLog(tag: tag, message: 'ERROR $e');
      return Left('Error');
    }
  }

  Future<Either<String, List<Agent>>> readAll() async {
    devLog(tag: tag, message: 'readAll');

    final cacheList = agentCache.values.toList();

    if (cacheList.isNotEmpty) {
      devLog(
          tag: tag,
          message: 'readAll loading from cache length${cacheList.length}');
      return Right(cacheList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await agentService.readAll();
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          agentCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }

  Future<Either<String, List<Agent>>> query(Map<String, dynamic> query) async {
    devLog(tag: tag, message: 'query');

    final cachedList = agentCache.values.where((e) => e.match(query)).toList();

    if (cachedList.isNotEmpty) {
      devLog(
        tag: tag,
        message: 'query loading from cache length${cachedList.length}',
      );
      return Right(cachedList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await agentService.queryContains(query);
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          agentCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }
}
