
    import 'package:either_dart/either.dart';
    import 'package:get_it/get_it.dart';
    import '../model/benchmark_validator.dart';
    import '../service/benchmark_validator_service.dart';
    import '../utils/logging.dart';

    BenchmarkValidatorRepository get benchmarkValidatorRepository => GetIt.instance<BenchmarkValidatorRepository>();

    class BenchmarkValidatorRepository {
      final tag = 'BenchmarkValidatorRepository';
      final modelCache = <String, BenchmarkValidator>{};

      Future<Either<String, BenchmarkValidator>> create({required BenchmarkValidator model}) async {
        devLog(tag: tag, message: 'create');
        try {
          final result = await benchmarkValidatorService.set(model: model);
          if (result.isRight) {
            devLog(tag: tag, message: 'create adding to cache');
            modelCache[result.right.id ?? ''] = result.right;
          }
          return result;
        } catch (e) {
          return Left('Error');
        }
      }


      Future<Either<String, BenchmarkValidator?>> read({required String id}) async {
        devLog(tag: tag, message: 'read');
        final cache = modelCache[id];

        if (cache != null) {
          devLog(tag: tag, message: 'read loading from cache');
          return Right(cache);
        } else {
          devLog(tag: tag, message: 'read loading from service');
          final result = await benchmarkValidatorService.read(id: id);
          if (result.isRight) {
            if (result.right != null) {
              devLog(tag: tag, message: 'read adding result to cache');
              modelCache[id] = result.right!;
            }
          }
          return result;
        }
      }

      Future<Either<String, BenchmarkValidator>> update({required BenchmarkValidator model}) async {
        try {
          devLog(tag: tag, message: 'update');
          final result = await benchmarkValidatorService.set(model: model);
          if (result.isRight) {
            modelCache[result.right.id ?? ''] = result.right;
          }
          return result;
        } catch (e) {
          return Left('Error');
        }
      }

      Future<Either<String, BenchmarkValidator?>> delete({required BenchmarkValidator model}) async {
        try {
          devLog(tag: tag, message: 'delete');
          final result = await benchmarkValidatorService.delete(model: model);
          if (result.isRight) {
            modelCache.remove(result.right.id ?? '');
          }
          return result;
        } catch (e) {
          return Left('Error');
        }
      }

     Future<Either<String, List<BenchmarkValidator>>> readAll() async {
        devLog(tag: tag, message: 'readAll');

        final cacheList = modelCache.values.toList();

        if (cacheList.isNotEmpty) {
          devLog(
              tag: tag,
              message: 'readAll loading from cache length${cacheList.length}');
          return Right(cacheList);
        } else {
          devLog(tag: tag, message: 'read loading from service');
          final result = await benchmarkValidatorService.readAll();
          if (result.isRight) {
            devLog(tag: tag, message: 'read adding result to cache');
            for (final element in result.right) {
              modelCache[element.id ?? ''] = element;
            }
          }
          return result;
        }
      }
      
    Future<Either<String, List<BenchmarkValidator>>> query(
      Map<String, dynamic> query) async {
    devLog(tag: tag, message: 'query');

    final cachedList = modelCache.values.where((e) => e.match(query)).toList();

    if (cachedList.isNotEmpty) {
      devLog(
        tag: tag,
        message: 'query loading from cache length${cachedList.length}',
      );
      return Right(cachedList);
    } else {
      devLog(tag: tag, message: 'read loading from service');
      final result = await benchmarkValidatorService.queryContains(query);
      if (result.isRight) {
        devLog(tag: tag, message: 'read adding result to cache');
        for (final element in result.right) {
          modelCache[element.id ?? ''] = element;
        }
      }
      return result;
    }
  }
    
    }
    