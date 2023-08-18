
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/model/benchmark_space.dart';
import 'package:open_llm_studio_api/repository/benchmark_space_repository.dart';
import 'package:open_llm_studio_api/service/benchmark_space_service.dart';
import 'package:mocktail/mocktail.dart';

main() {
  var repo = BenchmarkSpaceRepository();
  var service = MockBenchmarkSpaceService();
  var model = BenchmarkSpaceOld.fromJson(BenchmarkSpaceOld.exampleJson());

  setUpAll(() {
    registerFallbackValue(model);
  });

  setUp(() async {
    await GetIt.instance.reset();
    repo = BenchmarkSpaceRepository();
    service = MockBenchmarkSpaceService();
  });

  group('BenchmarkSpaceRepository can', () {
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
  
  test('ReadAll', () async {
      final exampleModel = BenchmarkSpaceOld.fromJson(BenchmarkSpaceOld.exampleJson());
      
      when(() => service.readAll()).thenAnswer(
            (invocation) => Future(() => Right([model])),
      );
      
      final readAllResult = await repo.readAll();
      expect(readAllResult.isRight, true);
      expect(readAllResult.right.length, 1);
    });
}

class MockBenchmarkSpaceService extends Mock implements BenchmarkSpaceService {
  MockBenchmarkSpaceService() {
    GetIt.instance.registerSingleton<BenchmarkSpaceService>(this);
  }
}
  