import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';

import '../model/long_term_memory.dart';
import '../util/logging.dart';
import 'firebase/firebase_service.dart';

MemoryPreviewService get memoryPreviewService =>
    GetIt.instance<MemoryPreviewService>();

class MemoryPreviewService {
  var firebase = firestoreService.firestore;
  final collectionName = 'MemoryPreview';

  CollectionReference get ref => firebase.collection(collectionName);
  final tag = 'MemoryPreviewService';

  Future<Either<String, MemoryPreview>> set({
    required MemoryPreview model,
  }) async {
    devLog(tag: tag, message: 'set called');
    try {
      final preview = MemoryPreview(
          memoryPreview: model.memoryPreview, id: model.id, name: model.name);

      if (model.id != null) {
        await ref.doc(model.id).set(preview.toJson());
      } else {
        // Handle the null ID scenario (like generating a new ID and then adding)
      }
      devLog(tag: tag, message: 'set success');

      return Right(preview);
    } catch (e) {
      print('$tag $e');
      return const Left('error');
    }
  }

  Future<Either<String, MemoryPreview?>> read({required String id}) async {
    devLog(tag: tag, message: 'read on ${id}');
    try {
      final result = await ref.doc(id).get();
      if (result.exists) {
        final parsed =
            MemoryPreview.fromJson(result.data() as Map<String, dynamic>);
        return Right(parsed);
      }
      return Right(null);
    } catch (e) {
      // logError('$tag $e');
      return Left('Error');
    }
  }

  Future<Either<String, List<MemoryPreview>>> readAll() async {
    devLog(tag: tag, message: 'readAll');
    try {
      final result = await ref.get();
      final parsedList = <MemoryPreview>[];
      for (final result in result.docs) {
        final parsed =
            MemoryPreview.fromJson(result.data() as Map<String, dynamic>);
        parsedList.add(parsed);
      }
      devLog(tag: tag, message: 'readAll success');

      return Right(parsedList);
    } catch (e) {
      print('$tag $e');
      return Left('Error');
    }
  }

  Future<Either<String, String>> delete({
    required String id,
  }) async {
    devLog(tag: tag, message: 'delete called');
    try {
      await ref.doc(id).delete();

      devLog(tag: tag, message: 'delete success');

      return const Right('success');
    } catch (e) {
      print('$tag $e');
      return const Left('error');
    }
  }
}
