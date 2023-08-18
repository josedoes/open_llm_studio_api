import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/agent.dart';
import 'package:open_llm_studio_api/service/agent_service.dart';
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
      GetIt.instance.registerSingleton<AgentService>(AgentService());
    },
  );

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });

  group('AgentService can', () {
    test('Create', () async {
      final exampleModel = Agent.fromJson(Agent.exampleJson());
      final setResult = await agentService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
    });

    test('Read', () async {
      final exampleModel = Agent.fromJson(Agent.exampleJson());
      final setResult = await agentService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readResult = await agentService.read(id: exampleModel.id ?? '');
      expect(readResult.isRight, true);
      expect(readResult.right, setResult.right);
    });

    test('ReadAll', () async {
      final exampleModel = Agent.fromJson(Agent.exampleJson());
      final setResult = await agentService.set(model: exampleModel);
      final setResult2 =
          await agentService.set(model: exampleModel.copyWith(id: '123'));
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readAllResult = await agentService.readAll();
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 2);
    });

    test('Query', () async {
      final exampleModel = Agent.fromJson(Agent.exampleJson());
      final setResult = await agentService.set(model: exampleModel);
      final setResult2 =
          await agentService.set(model: exampleModel.copyWith(id: '123'));
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readAllResult =
          await agentService.queryContains({'id': exampleModel.id});
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 1);
    });
  });
}
