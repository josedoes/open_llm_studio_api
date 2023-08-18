import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';

import '../model/long_term_memory.dart';
import '../utils/logging.dart';
import 'cloud_storage_service.dart';

LongTermMemoryService get longTermMemoryService =>
    GetIt.instance<LongTermMemoryService>();

class LongTermMemoryService {
  final tag = 'LongTermMemory';
  final collectionName = 'LongTermMemory';

  Future<Either<String, LongtermMemory>> set({
    required LongtermMemory model,
  }) async {
    devLog(tag: tag, message: 'set called');
    try {
      await cloudStorageService.uploadString(
        json.encode(model.toJson()),
        '$collectionName/${model.id ?? ''}',
      );
      devLog(tag: tag, message: 'set success');

      return Right(model);
    } catch (e) {
      print('$tag $e');
      return const Left('error');
    }
  }

  Future<Either<String, LongtermMemory>> read(String id) async {
    devLog(tag: tag, message: 'read called');
    try {
      var result = await cloudStorageService.downloadInMemory(
          '$collectionName/$id', null);
      if (result != null) {
        final json = convertToValidJson(result);
        final map = jsonDecode(json ?? '');
        final memory = LongtermMemory.fromJson(map);
        devLog(tag: tag, message: 'read success');

        return Right(memory);
      } else {
        print('$tag read came out null');
        return Left('error');
      }
    } catch (e) {
      print('$tag $e');
      return Left('error');
    }
  }

  Future<Either<String, List<LongtermMemory>>> readMultiple(
      List<String> ids) async {
    devLog(tag: tag, message: 'readMultiple called');
    try {
      List<LongtermMemory> memories = [];
      for (final i in ids) {
        final result = await read(i);
        if (result.isRight) {
          memories.add(result.right);
        }
      }
      return Right(memories);
    } catch (e) {
      print('$tag $e');
      return Left('error');
    }
  }

  String? convertToValidJson(String data) {
    // Replace single quotes with double quotes for valid JSON format
    String jsonData = data.replaceAllMapped(RegExp(r"(\\*)'"), (match) {
      return match.group(1)! + '\"';
    });
    try {
      json.decode(jsonData);
    } catch (e) {
      print("Invalid JSON format");
      return null;
    }

    return jsonData;
  }

  Future<Either<String, String>> delete({
    required String id,
  }) async {
    devLog(tag: tag, message: 'delete called');
    try {
      await cloudStorageService.deleteFile('$collectionName/$id');
      devLog(tag: tag, message: 'delete success');

      return const Right('success');
    } catch (e) {
      print('$tag $e');
      return const Left('error');
    }
  }
}
