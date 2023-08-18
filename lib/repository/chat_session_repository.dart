import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import '../model/chat_session.dart';
import '../service/chat_session_service.dart';
import '../utils/logging.dart';

ChatSessionModelRepository get chatSessionModelRepository => GetIt.instance<ChatSessionModelRepository>();

class ChatSessionModelRepository {
  final tag = 'ChatSessionModelRepository';
  final chatSessionModelCache = <String, ChatSessionModel>{};

  Future<Either<String, ChatSessionModel>> create({required ChatSessionModel model}) async {
    devLog(tag: tag, message: 'create');
    try {
      final result = await chatSessionModelService.set(model: model);
      if (result.isRight) {
        devLog(tag: tag, message: 'create adding to cache');
        chatSessionModelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, ChatSessionModel?>> read({required String id}) async {
    devLog(tag: tag, message: 'read');
    final cache = chatSessionModelCache[id];

    if (cache != null) {
      devLog(tag: tag, message: 'read loading from cache');
      return Right(cache);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await chatSessionModelService.read(id: id);
      if (result.isRight) {
        if (result.right != null) {
          devLog(tag: tag, message: 'read adding result to cache');
          chatSessionModelCache[id] = result.right!;
        }
      }
      return result;
    }
  }

  Future<Either<String, ChatSessionModel>> update({required ChatSessionModel model}) async {
    try {
      devLog(tag: tag, message: 'update');
      final result = await chatSessionModelService.set(model: model);
      if (result.isRight) {
        chatSessionModelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, ChatSessionModel?>> delete({required ChatSessionModel model}) async {
    try {
      devLog(tag: tag, message: 'delete');
      final result = await chatSessionModelService.delete(model: model);
      if (result.isRight) {
        chatSessionModelCache.remove(result.right.id ?? '');
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, List<ChatSessionModel>>> readAll() async {
    devLog(tag: tag, message: 'readAll');

    final cacheList = chatSessionModelCache.values.toList();

    if (cacheList.isNotEmpty) {
      devLog(
          tag: tag,
          message: 'readAll loading from cache length${cacheList.length}');
      return Right(cacheList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await chatSessionModelService.readAll();
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          chatSessionModelCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }

  Future<Either<String, List<ChatSessionModel>>> query(Map<String, dynamic> query) async {
    devLog(tag: tag, message: 'query');

    final cachedList = chatSessionModelCache.values.where((e) => e.match(query)).toList();

    if (cachedList.isNotEmpty) {
      devLog(
        tag: tag,
        message: 'query loading from cache length${cachedList.length}',
      );
      return Right(cachedList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await chatSessionModelService.queryContains(query);
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          chatSessionModelCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }
}
