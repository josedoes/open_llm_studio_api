
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/question.dart';
import 'package:open_llm_studio_api/repository/question_repository.dart';
import 'package:open_llm_studio_api/service/question_service.dart';
import 'package:mocktail/mocktail.dart';

main() {
  var repo = QuestionRepository();
  var service = MockQuestionService();
  var model = Question.fromJson(Question.exampleJson());

  setUpAll(() {
    registerFallbackValue(model);
  });

  setUp(() async {
    await GetIt.instance.reset();
    repo = QuestionRepository();
    service = MockQuestionService();
  });

  group('QuestionRepository can', () {
    test('create', () async {
      when(() => service.set(model: model)).thenAnswer(
        (invocation) => Future(() => Right(model)),
      );

      final createResult = await repo.create(model: model);

      verify(() => service.set(model: model)).called(1);

      expect(createResult.right, model);
      expect(repo.modelCache.length, 1);
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
      expect(repo.modelCache.values.length, 1);

      final deleteResult = await repo.delete(model: model);

      verify(() => service.delete(model: model)).called(1);

      expect(repo.modelCache.values.length, 0);
      expect(deleteResult.right, model);
    });
  });
}

class MockQuestionService extends Mock implements QuestionService {
  MockQuestionService() {
    GetIt.instance.registerSingleton<QuestionService>(this);
  }
}
  