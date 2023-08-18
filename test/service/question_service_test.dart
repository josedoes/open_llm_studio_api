import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/question.dart';
import 'package:open_llm_studio_api/service/firebase/firebase_service.dart';
import 'package:open_llm_studio_api/service/question_service.dart';
import 'package:mocktail/mocktail.dart';

import '../data/mocks.dart';

main() {
  FakeFirebaseFirestore? fakeFirebaseFirestore;
  MockFirestoreService();

  setUpAll(
    () {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
      when(() => firestoreService.firestore).thenAnswer(
        (invocation) => fakeFirebaseFirestore!,
      );
      GetIt.instance.registerSingleton<QuestionService>(QuestionService());
    },
  );

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });

  group('QuestionService can', () {
    test('Create', () async {
      final exampleModel = Question.fromJson(Question.exampleJson());
      final setResult = await questionService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
    });

    test('Read', () async {
      final exampleModel = Question.fromJson(Question.exampleJson());
      final setResult = await questionService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readResult = await questionService.read(id: exampleModel.id ?? '');
      expect(readResult.isRight, true);
      expect(readResult.right, setResult.right);
    });

    test('Delete', () async {
      final exampleModel = Question.fromJson(Question.exampleJson());
      final setResult = await questionService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final deleteResult = await questionService.delete(model: exampleModel);
      expect(deleteResult.isRight, true);
      expect(deleteResult.right, setResult.right);
    });
  });
}
