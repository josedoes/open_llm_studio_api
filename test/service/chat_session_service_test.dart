import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/chat_session.dart';
import 'package:open_llm_studio_api/service/chat_session_service.dart';
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
      GetIt.instance.registerSingleton<ChatSessionModelService>(
          ChatSessionModelService());
    },
  );

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });

  group('ChatSessionModelService can', () {
    test('Create', () async {
      final exampleModel =
          ChatSessionModel.fromJson(ChatSessionModel.exampleJson());
      final setResult =
          await chatSessionModelService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
    });

    test('Read', () async {
      final exampleModel =
          ChatSessionModel.fromJson(ChatSessionModel.exampleJson());
      final setResult =
          await chatSessionModelService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readResult =
          await chatSessionModelService.read(id: exampleModel.id ?? '');
      expect(readResult.isRight, true);
      expect(readResult.right, setResult.right);
    });

    test('ReadAll', () async {
      final exampleModel =
          ChatSessionModel.fromJson(ChatSessionModel.exampleJson());
      final setResult =
          await chatSessionModelService.set(model: exampleModel);
      final setResult2 = await chatSessionModelService.set(
          model: exampleModel.copyWith(id: '123'));
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readAllResult = await chatSessionModelService.readAll();
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 2);
    });

    test('Query', () async {
      final exampleModel =
          ChatSessionModel.fromJson(ChatSessionModel.exampleJson());
      final setResult =
          await chatSessionModelService.set(model: exampleModel);
      final setResult2 = await chatSessionModelService.set(
          model: exampleModel.copyWith(id: '123'));
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readAllResult = await chatSessionModelService
          .queryContains({'id': exampleModel.id});
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 1);
    });
  });
}
