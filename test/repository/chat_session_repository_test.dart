
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/chat_session.dart';
import 'package:open_llm_studio_api/repository/chat_session_repository.dart';
import 'package:open_llm_studio_api/service/chat_session_service.dart';
import 'package:mocktail/mocktail.dart';

main() {
  var repo = ChatSessionModelRepository();
  var service = MockChatSessionModelService();
  var model = ChatSessionModel.fromJson(ChatSessionModel.exampleJson());

  setUpAll(() {
    registerFallbackValue(model);
  });

  setUp(() async {
    await GetIt.instance.reset();
    repo = ChatSessionModelRepository();
    service = MockChatSessionModelService();
  });

  group('ChatSessionModelRepository can', () {
    test('create', () async {
      when(() => service.set(model: model)).thenAnswer(
        (invocation) => Future(() => Right(model)),
      );

      final createResult = await repo.create(model: model);

      verify(() => service.set(model: model)).called(1);

      expect(createResult.right, model);
      expect(repo.chatSessionModelCache.length, 1);
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
      expect(repo.chatSessionModelCache.values.length, 1);

      final deleteResult = await repo.delete(model: model);

      verify(() => service.delete(model: model)).called(1);

      expect(repo.chatSessionModelCache.values.length, 0);
      expect(deleteResult.right, model);
    });
  });
  
  test('ReadAll', () async {
      final exampleModel = ChatSessionModel.fromJson(ChatSessionModel.exampleJson());
      
      when(() => service.readAll()).thenAnswer(
            (invocation) => Future(() => Right([model])),
      );
      
      final readAllResult = await repo.readAll();
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 1);
    });
    
  test('Query', () async {
    final exampleModel = ChatSessionModel.fromJson(ChatSessionModel.exampleJson());
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

class MockChatSessionModelService extends Mock implements ChatSessionModelService {
  MockChatSessionModelService() {
    GetIt.instance.registerSingleton<ChatSessionModelService>(this);
  }
}
  