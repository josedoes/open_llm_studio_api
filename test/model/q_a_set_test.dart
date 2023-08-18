import 'package:flutter_test/flutter_test.dart';
import '../../lib/model/q_a_set.dart';

void main() async {
  group('QASet', () {
    test('parseSample', () {
      var exampleJson = QASet.exampleJson();
      var parse = QASet.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = QASet.fromJson({});
    });
    test('query empty', () {
      var exampleJson = QASet.exampleJson();
      var parse = QASet.fromJson(exampleJson);
      final emptyShouldBeFalse = parse.match({});
      final expectedFalse = parse.match({"id":true});
      final expectedTrue = parse.match(exampleJson);
      expect(expectedTrue, true);
      expect(emptyShouldBeFalse, false);
      expect(expectedFalse, false);
    });
  });
}