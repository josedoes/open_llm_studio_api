
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/llm_space.dart';
import 'package:open_llm_studio_api/repository/llm_space_repository.dart';
import 'package:open_llm_studio_api/service/llm_space_service.dart';
import 'package:mocktail/mocktail.dart';

main() {
  var repo = LlmSpaceRepository();
  var service = MockLlmSpaceService();
  var model = LlmSpace.fromJson(LlmSpace.exampleJson());

  setUpAll(() {
    registerFallbackValue(model);
  });

  setUp(() async {
    await GetIt.instance.reset();
    repo = LlmSpaceRepository();
    service = MockLlmSpaceService();
  });

  group('LlmSpaceRepository can', () {
    test('create', () async {
      when(() => service.set(model: model)).thenAnswer(
        (invocation) => Future(() => Right(model)),
      );

      final createResult = await repo.create(model: model);

      verify(() => service.set(model: model)).called(1);

      expect(createResult.right, model);
      expect(repo.llmSpaceCache.length, 1);
    });

    test('read', () async {
      when(() => service.read(id: any(named: 'id'))).thenAnswer(
        (invocation) => Future(() => Right(model)),
      );

      final readResult1 = await repo.read(id: model.id ?? '');
      final readResult2 = await repo.read(id: model.id ?? '');

      verify(() => service.read(id: any(named: 'id'))).called(1);

      expect(readResult1.right, readResult2.right);
    });

    test('delete', () async {
      when(() => service.delete(model: model)).thenAnswer(
            (invocation) => Future(() => Right(model)),
      );

      when(() => service.set(model: model)).thenAnswer(
            (invocation) => Future(() => Right(model)),
      );

      final createResult = await repo.create(model: model);
      expect(repo.llmSpaceCache.values.length, 1);

      final deleteResult = await repo.delete(model: model);

      verify(() => service.delete(model: model)).called(1);

      expect(repo.llmSpaceCache.values.length, 0);
      expect(deleteResult.right, model);
    });
  });
  
  test('ReadAll', () async {
      final exampleModel = LlmSpace.fromJson(LlmSpace.exampleJson());
      
      when(() => service.readAll()).thenAnswer(
            (invocation) => Future(() => Right([model])),
      );
      
      final readAllResult = await repo.readAll();
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 1);
    });
    
  test('Query', () async {
    final exampleModel = LlmSpace.fromJson(LlmSpace.exampleJson());
    final query = {'id': exampleModel.id};

    when(() => service.queryContains(query)).thenAnswer(
      (invocation) => Future(() => Right([exampleModel])),
    );
      
    when(() => service.queryContains({})).thenAnswer(
      (invocation) => Future(() => Right([])),
    );

    final readAllResult = await repo.query({});
    expect(readAllResult.isRight, true);
    expect(readAllResult.right.length, 0);

    final queryExpectResults = await repo.query(query);
    expect(queryExpectResults.isRight, true);
    expect(queryExpectResults.right.length, 1);

    final second = await repo.query(query);

    verify(() => service.queryContains(query)).called(1);
    verify(() => service.queryContains({})).called(1);

  });  
}

class MockLlmSpaceService extends Mock implements LlmSpaceService {
  MockLlmSpaceService() {
    GetIt.instance.registerSingleton<LlmSpaceService>(this);
  }
}
  