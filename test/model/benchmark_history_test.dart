import 'package:flutter_test/flutter_test.dart';
import '../../lib/model/benchmark_history.dart';

void main() async {
  group('BenchmarkHistory', () {
    test('parseSample', () {
      var exampleJson = BenchmarkHistory.exampleJson();
      var parse = BenchmarkHistory.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = BenchmarkHistory.fromJson({});
    });
    test('query empty', () {
      var exampleJson = BenchmarkHistory.exampleJson();
      var parse = BenchmarkHistory.fromJson(exampleJson);
      final emptyShouldBeFalse = parse.match({});
      final expectedFalse = parse.match({"id":true});
      final expectedTrue = parse.match(exampleJson);
      expect(expectedTrue, true);
      expect(emptyShouldBeFalse, false);
      expect(expectedFalse, false);
    });
  });
}