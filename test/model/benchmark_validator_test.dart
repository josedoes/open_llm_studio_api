import 'package:flutter_test/flutter_test.dart';
import '../../lib/model/benchmark_validator.dart';

void main() async {
  group('BenchmarkValidator', () {
    test('parseSample', () {
      var exampleJson = BenchmarkValidator.exampleJson();
      var parse = BenchmarkValidator.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = BenchmarkValidator.fromJson({});
    });
    test('query empty', () {
      var exampleJson = BenchmarkValidator.exampleJson();
      var parse = BenchmarkValidator.fromJson(exampleJson);
      final emptyShouldBeFalse = parse.match({});
      final expectedFalse = parse.match({"id":true});
      final expectedTrue = parse.match(exampleJson);
      expect(expectedTrue, true);
      expect(emptyShouldBeFalse, false);
      expect(expectedFalse, false);
    });
  });
}