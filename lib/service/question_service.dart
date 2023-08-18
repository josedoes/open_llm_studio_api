import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';

import '../model/question.dart';
import '../service/firebase/firebase_service.dart';
import '../utils/logging.dart';

QuestionService get questionService => GetIt.instance<QuestionService>();

class QuestionService {
  final tag = 'Question';
  var firebase = firestoreService.firestore;
  final collectionName = 'Question';

  CollectionReference get ref => firebase.collection(collectionName);

  Future<Either<String, Question>> set({
    Question? model,
  }) async {
    devLog(tag: tag, message: 'set called');
    try {
      final sample = Question.fromJson(Question.exampleJson());
      final doc = model ?? sample;

      await ref.doc(doc.id).set(
            doc.toJson(),
          );
      return Right(doc);
    } catch (e) {
      // logError('$tag $e');
      return Left('error');
    }
  }

  Future<Either<String, Question>> delete({required Question model}) async {
    try {
      devLog(tag: tag, message: 'delete on ${model.id}');
      await ref.doc(model.id).delete();
      final result = await ref.doc(model.id).delete();
      return Right(model);
    } catch (e) {
      // logError('$tag $e');
      return Left('Error');
    }
  }

  Future<Either<String, Question?>> read({required String id}) async {
    devLog(tag: tag, message: 'read on ${id}');
    try {
      final result = await ref.doc(id).get();
      if (result.exists) {
        final parsed = Question.fromJson(result.data() as Map<String, dynamic>);
        return Right(parsed);
      }
      return Right(null);
    } catch (e) {
      // logError('$tag $e');
      return Left('Error');
    }
  }
}
