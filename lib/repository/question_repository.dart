
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import '../model/question.dart';
import '../service/question_service.dart';
import '../utils/logging.dart';

QuestionRepository get questionRepository => GetIt.instance<QuestionRepository>();

class QuestionRepository {
  final tag = 'QuestionRepository';
  final modelCache = <String, Question>{};

  Future<Either<String, Question>> create({required Question model}) async {
    devLog(tag: tag, message: 'create');
    try {
      final result = await questionService.set(model: model);
      if (result.isRight) {
        devLog(tag: tag, message: 'create adding to cache');
        modelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }


  Future<Either<String, Question?>> read({required String id}) async {
    devLog(tag: tag, message: 'read');
    final cache = modelCache[id];

    if (cache != null) {
      devLog(tag: tag, message: 'read loading from cache');
      return Right(cache);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await questionService.read(id: id);
      if (result.isRight) {
        if (result.right != null) {
          devLog(tag: tag, message: 'read adding result to cache');
          modelCache[id] = result.right!;
        }
      }
      return result;
    }
  }

  Future<Either<String, Question>> update({required Question model}) async {
    try {
      devLog(tag: tag, message: 'update');
      final result = await questionService.set(model: model);
      return result;
      if (result.isRight) {
        modelCache[result.right.id ?? ''] = result.right;
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }

  Future<Either<String, Question?>> delete({required Question model}) async {
    try {
      devLog(tag: tag, message: 'delete');
      final result = await questionService.delete(model: model);
      if (result.isRight) {
        modelCache.remove(result.right.id ?? '');
      }
      return result;
    } catch (e) {
      return Left('Error');
    }
  }
}
