import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/benchmark_history.dart';
import 'package:open_llm_studio_api/service/benchmark_history_service.dart';
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
      GetIt.instance.registerSingleton<BenchmarkHistoryService>(
          BenchmarkHistoryService());
    },
  );

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });

  group('BenchmarkHistoryService can', () {
    test('Create', () async {
      final exampleModel =
          BenchmarkHistory.fromJson(BenchmarkHistory.exampleJson());
      final setResult =
          await benchmarkHistoryService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
    });

    test('Read', () async {
      final exampleModel =
          BenchmarkHistory.fromJson(BenchmarkHistory.exampleJson());
      final setResult =
          await benchmarkHistoryService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readResult =
          await benchmarkHistoryService.read(id: exampleModel.id ?? '');
      expect(readResult.isRight, true);
      expect(readResult.right, setResult.right);
    });

    test('ReadAll', () async {
      final exampleModel =
          BenchmarkHistory.fromJson(BenchmarkHistory.exampleJson());
      final setResult =
          await benchmarkHistoryService.set(model: exampleModel);
      final setResult2 = await benchmarkHistoryService.set(
          model: exampleModel.copyWith(id: '123'));
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readAllResult = await benchmarkHistoryService.readAll();
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 2);
    });

    test('Query', () async {
      final exampleModel =
          BenchmarkHistory.fromJson(BenchmarkHistory.exampleJson());
      final setResult =
          await benchmarkHistoryService.set(model: exampleModel);
      final setResult2 = await benchmarkHistoryService.set(
          model: exampleModel.copyWith(id: '123'));
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
      final readAllResult = await benchmarkHistoryService
          .queryContains({'id': exampleModel.id});
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 1);
    });
  });
}
