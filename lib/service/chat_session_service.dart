import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';

import '../model/chat_session.dart';
import '../service/firebase/firebase_service.dart';
import '../utils/logging.dart';

ChatSessionModelService get chatSessionModelService =>
    GetIt.instance<ChatSessionModelService>();

class ChatSessionModelService {
  final tag = 'ChatSessionModel';
  var firebase = firestoreService.firestore;
  final collectionName = 'ChatSessionModel';

  CollectionReference get ref => firebase.collection(collectionName);

  Future<Either<String, ChatSessionModel>> set({
    ChatSessionModel? model,
  }) async {
    devLog(tag: tag, message: 'set called');
    try {
      final sample =
          ChatSessionModel.fromJson(ChatSessionModel.exampleJson());
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

  Future<Either<String, ChatSessionModel>> delete(
      {required ChatSessionModel model}) async {
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

  Future<Either<String, ChatSessionModel?>> read({required String id}) async {
    devLog(tag: tag, message: 'read on ${id}');
    try {
      final result = await ref.doc(id).get();
      if (result.exists) {
        final parsed =
            ChatSessionModel.fromJson(result.data() as Map<String, dynamic>);
        return Right(parsed);
      }
      return Right(null);
    } catch (e) {
      // logError('$tag $e');
      return Left('Error');
    }
  }

  Future<Either<String, List<ChatSessionModel>>> readAll() async {
    devLog(tag: tag, message: 'readAll');
    try {
      final result = await ref.get();
      final parsedList = <ChatSessionModel>[];
      for (final result in result.docs) {
        final parsed =
            ChatSessionModel.fromJson(result.data() as Map<String, dynamic>);
        parsedList.add(parsed);
      }
      return Right(parsedList);
    } catch (e) {
      // logError('$tag $e');
      return Left('Error');
    }
  }

  Future<Either<String, List<ChatSessionModel>>> queryContains(
      Map<String, dynamic> query) async {
    devLog(tag: tag, message: 'queryContains called with ${query}');
    try {
      if (query.isEmpty) {
        return Left('Error: Query is not correct');
      }

      Query _query = ref; // Initial reference

      final entries = query.entries.toList();
      for (int i = 0; i < entries.length; i++) {
        final current = entries[i];
        _query = _query.where(current.key,
            isEqualTo: current
                .value); // Notice we are using current.key here, and also re-assigning the result to _query
      }

      final result = await _query.get();

      final parsedList = <ChatSessionModel>[];
      for (final doc in result.docs) {
        final parsed =
            ChatSessionModel.fromJson(doc.data() as Map<String, dynamic>);
        parsedList.add(parsed);
      }

      return Right(parsedList);
    } catch (e) {
      // logError('$tag $e');
      return Left('Error');
    }
  }
}
