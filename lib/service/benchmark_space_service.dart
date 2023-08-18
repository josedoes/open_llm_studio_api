import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';

import '../model/benchmark_space.dart';
import '../service/firebase/firebase_service.dart';
import '../utils/logging.dart';

BenchmarkSpaceService get benchmarkSpaceService =>
    GetIt.instance<BenchmarkSpaceService>();

class BenchmarkSpaceService {
  final tag = 'BenchmarkSpace';
  var firebase = firestoreService.firestore;
  final collectionName = 'BenchmarkSpace';

  CollectionReference get ref => firebase.collection(collectionName);

  Future<Either<String, BenchmarkSpaceOld>> set({
    BenchmarkSpaceOld? model,
  }) async {
    devLog(tag: tag, message: 'set called');
    try {
      final sample =
          BenchmarkSpaceOld.fromJson(BenchmarkSpaceOld.exampleJson());
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

  Future<Either<String, BenchmarkSpaceOld>> delete(
      {required BenchmarkSpaceOld model}) async {
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

  Future<Either<String, BenchmarkSpaceOld?>> read({required String id}) async {
    devLog(tag: tag, message: 'read on ${id}');
    try {
      final result = await ref.doc(id).get();
      if (result.exists) {
        final parsed =
            BenchmarkSpaceOld.fromJson(result.data() as Map<String, dynamic>);
        return Right(parsed);
      }
      return Right(null);
    } catch (e) {
      // logError('$tag $e');
      return Left('Error');
    }
  }

  Future<Either<String, List<BenchmarkSpaceOld>>> readAll() async {
    devLog(tag: tag, message: 'readAll');
    try {
      final result = await ref.get();
      final parsedList = <BenchmarkSpaceOld>[];
      for (final result in result.docs) {
        final parsed =
            BenchmarkSpaceOld.fromJson(result.data() as Map<String, dynamic>);
        parsedList.add(parsed);
      }
      return Right(parsedList);
    } catch (e) {
      // logError('$tag $e');
      return Left('Error');
    }
  }
}
