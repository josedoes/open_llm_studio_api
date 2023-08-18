import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/long_term_memory.dart';
import 'package:open_llm_studio_api/service/long_term_memory_service.dart';
import 'package:mocktail/mocktail.dart';

import '../data/mocks.dart';

void main() {
  late MockCloudStorageService cloudStorageServiceMock;
  final collectionName = 'LongTermMemory';

  setUpAll(() {
    cloudStorageServiceMock = MockCloudStorageService();

    GetIt.instance
        .registerSingleton<LongTermMemoryService>(LongTermMemoryService());
  });

  group('LongTermMemoryService can', () {
    // test('Create', () async {
    //   final exampleModel =
    //       LongtermMemory.fromJson(LongtermMemory.exampleJson());
    //
    //   when(() => cloudStorageServiceMock.uploadString(
    //         "${exampleModel.toJson()}",
    //         '$collectionName/${exampleModel.id}',
    //       )).thenAnswer((invocation) => Future.value());
    //
    //   final setResult = await longTermMemoryService.set(model: exampleModel);
    //   expect(setResult.isRight, true);
    // });

    // test('Read', () async {
    //   final exampleModel =
    //       LongtermMemory.fromJson(LongtermMemory.exampleJson());
    //   when(() => cloudStorageServiceMock
    //       .downloadInMemory('$collectionName/${exampleModel.id}', null)
    //       .then((invocation) => Future.value('')));
    //
    //   final readResult =
    //       await longTermMemoryService.read(exampleModel.id ?? '');
    //
    //   expect(readResult.isRight, true);
    // });

    // Note: The 'readAll' functionality is not provided in the new service, so it's omitted here.

    test('Delete', () async {
      final exampleModel =
          LongtermMemory.fromJson(LongtermMemory.exampleJson());

      when(() => cloudStorageServiceMock.deleteFile(
            '$collectionName/${exampleModel.id}',
          )).thenAnswer((invocation) => Future.value());

      final deleteResult =
          await longTermMemoryService.delete(id: exampleModel.id ?? '');

      expect(deleteResult.isRight, true);
    });
  });
}
