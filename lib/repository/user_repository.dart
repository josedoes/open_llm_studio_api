import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import '../model/user.dart';
import '../service/user_service.dart';
import '../utils/logging.dart';

UserModelRepository get userModelRepository =>
    GetIt.instance<UserModelRepository>();

class UserModelRepository {
  final tag = 'UserModelRepository';
  final userModelCache = <String, UserModel>{};

  Future<Either<String, UserModel>> create({required UserModel model}) async {
    devLog(tag: tag, message: 'create');
    try {
      final result = await userModelService.set(model: model);
      if (result.isRight) {
        devLog(tag: tag, message: 'create adding to cache');
        userModelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, UserModel?>> read({required String id}) async {
    devLog(tag: tag, message: 'read');
    final cache = userModelCache[id];

    if (cache != null) {
      devLog(tag: tag, message: 'read loading from cache');
      return Right(cache);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await userModelService.read(id: id);
      if (result.isRight) {
        if (result.right != null) {
          devLog(tag: tag, message: 'read adding result to cache');
          userModelCache[id] = result.right!;
        }
      }
      return result;
    }
  }

  Future<Either<String, UserModel>> update({required UserModel model}) async {
    try {
      devLog(tag: tag, message: 'update');
      final result = await userModelService.set(model: model);
      if (result.isRight) {
        userModelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, UserModel?>> delete({required UserModel model}) async {
    try {
      devLog(tag: tag, message: 'delete');
      final result = await userModelService.delete(model: model);
      if (result.isRight) {
        userModelCache.remove(result.right.id ?? '');
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, List<UserModel>>> readAll() async {
    devLog(tag: tag, message: 'readAll');

    final cacheList = userModelCache.values.toList();

    if (cacheList.isNotEmpty) {
      devLog(
          tag: tag,
          message: 'readAll loading from cache length${cacheList.length}');
      return Right(cacheList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await userModelService.readAll();
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          userModelCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }

  Future<Either<String, List<UserModel>>> query(
      Map<String, dynamic> query) async {
    devLog(tag: tag, message: 'query');

    final cachedList =
        userModelCache.values.where((e) => e.match(query)).toList();

    if (cachedList.isNotEmpty) {
      devLog(
        tag: tag,
        message: 'query loading from cache length${cachedList.length}',
      );
      return Right(cachedList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await userModelService.queryContains(query);
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          userModelCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }
}
