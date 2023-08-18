import 'package:flutter_test/flutter_test.dart';
import '../../lib/model/question.dart';

void main() async {
  group('Question', () {
    test('parseSample', () {
      var exampleJson = Question.exampleJson();
      var parse = Question.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = Question.fromJson({});
    });
  });
}