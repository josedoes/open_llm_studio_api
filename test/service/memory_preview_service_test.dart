import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/long_term_memory.dart';
import 'package:open_llm_studio_api/service/firebase/firebase_service.dart';
import 'package:open_llm_studio_api/service/memory_preview_service.dart';
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
      GetIt.instance
          .registerSingleton<MemoryPreviewService>(MemoryPreviewService());
    },
  );

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });

  group('MemoryPreviewService can', () {
    test('Create', () async {
      final exampleModel = MemoryPreview.fromJson(MemoryPreview.exampleJson());
      final setResult = await memoryPreviewService.set(model: exampleModel);
      expect(setResult.isRight, true);
      expect(setResult.right, exampleModel);
    });

    test('ReadAll', () async {
      final exampleModel = MemoryPreview.fromJson(MemoryPreview.exampleJson());
      await memoryPreviewService.set(model: exampleModel);
      final exampleModel2 = exampleModel.copyWith(id: '123');
      await memoryPreviewService.set(model: exampleModel2);
      final readAllResult = await memoryPreviewService.readAll();
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 2);
    });

    test('Delete', () async {
      final exampleModel = MemoryPreview.fromJson(MemoryPreview.exampleJson());
      await memoryPreviewService.set(model: exampleModel);
      final deleteResult =
          await memoryPreviewService.delete(id: exampleModel.id ?? '');
      expect(deleteResult.isRight, true);
      expect(deleteResult.right, 'success');
    });
  });
}
