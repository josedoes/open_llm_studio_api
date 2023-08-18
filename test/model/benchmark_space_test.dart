import 'package:flutter_test/flutter_test.dart';
import '../../lib/model/benchmark_space.dart';

void main() async {
  group('BenchmarkSpace', () {
    test('parseSample', () {
      var exampleJson = BenchmarkSpaceOld.exampleJson();
      var parse = BenchmarkSpaceOld.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = BenchmarkSpaceOld.fromJson({});
    });
  });
}