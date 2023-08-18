import 'package:flutter_test/flutter_test.dart';
import '../../lib/model/llm_space.dart';

void main() async {
  group('LlmSpace', () {
    test('parseSample', () {
      var exampleJson = LlmSpace.exampleJson();
      var parse = LlmSpace.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = LlmSpace.fromJson({});
    });
    test('query empty', () {
      var exampleJson = LlmSpace.exampleJson();
      var parse = LlmSpace.fromJson(exampleJson);
      final emptyShouldBeFalse = parse.match({});
      final expectedFalse = parse.match({"id":true});
      final expectedTrue = parse.match(exampleJson);
      expect(expectedTrue, true);
      expect(emptyShouldBeFalse, false);
      expect(expectedFalse, false);
    });
  });
}