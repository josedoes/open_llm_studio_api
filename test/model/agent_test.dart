import 'package:flutter_test/flutter_test.dart';
import '../../lib/model/agent.dart';

void main() async {
  group('Agent', () {
    test('parseSample', () {
      var exampleJson = Agent.exampleJson();
      var parse = Agent.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = Agent.fromJson({});
    });
    test('query empty', () {
      var exampleJson = Agent.exampleJson();
      var parse = Agent.fromJson(exampleJson);
      final emptyShouldBeFalse = parse.match({});
      final expectedFalse = parse.match({"id":true});
      final expectedTrue = parse.match(exampleJson);
      expect(expectedTrue, true);
      expect(emptyShouldBeFalse, false);
      expect(expectedFalse, false);
    });
  });
}