import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/llm_space.dart';
import 'package:open_llm_studio_api/service/llm_space_service.dart';
import 'package:open_llm_studio_api/service/firebase/firebase_service.dart';
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
      GetIt.instance.registerSingleton<LlmSpaceService>(
          LlmSpaceService());
    },
  );

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });

  group('LlmSpaceService can', () {
    test('Create', () async {
      final exampleModel =
          LlmSpace.fromJson(LlmSpace.exampleJson());
      final setResult =
          await llmSpaceService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
    });

    test('Read', () async {
      final exampleModel =
          LlmSpace.fromJson(LlmSpace.exampleJson());
      final setResult =
          await llmSpaceService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readResult =
          await llmSpaceService.read(id: exampleModel.id ?? '');
      expect(readResult.isRight, true);
      expect(readResult.right, setResult.right);
    });

    test('ReadAll', () async {
      final exampleModel =
          LlmSpace.fromJson(LlmSpace.exampleJson());
      final setResult =
          await llmSpaceService.set(model: exampleModel);
      final setResult2 = await llmSpaceService.set(
          model: exampleModel.copyWith(id: '123'));
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readAllResult = await llmSpaceService.readAll();
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 2);
    });

    test('Query', () async {
      final exampleModel =
          LlmSpace.fromJson(LlmSpace.exampleJson());
      final setResult =
          await llmSpaceService.set(model: exampleModel);
      final setResult2 = await llmSpaceService.set(
          model: exampleModel.copyWith(id: '123'));
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readAllResult = await llmSpaceService
          .queryContains({'id': exampleModel.id});
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 1);
    });
  });
}
