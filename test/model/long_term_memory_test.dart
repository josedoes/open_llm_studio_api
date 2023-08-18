import 'package:flutter_test/flutter_test.dart';

import '../../lib/model/long_term_memory.dart';

void main() async {
  group('LongTermMemory', () {
    test('parseSample', () {
      var exampleJson = LongtermMemory.exampleJson();
      var parse = LongtermMemory.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = LongtermMemory.fromJson({});
    });
    test('query empty', () {
      var exampleJson = LongtermMemory.exampleJson();
      var parse = LongtermMemory.fromJson(exampleJson);
      final emptyShouldBeFalse = parse.match({});
      final expectedFalse = parse.match({"id": true});
      final expectedTrue = parse.match(exampleJson);
      expect(expectedTrue, true);
      expect(emptyShouldBeFalse, false);
      expect(expectedFalse, false);
    });
  });
}
