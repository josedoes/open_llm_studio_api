import 'package:flutter_test/flutter_test.dart';
import '../../lib/model/chat_session.dart';

void main() async {
  group('ChatSessionModel', () {
    test('parseSample', () {
      var exampleJson = ChatSessionModel.exampleJson();
      var parse = ChatSessionModel.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = ChatSessionModel.fromJson({});
    });
    test('query empty', () {
      var exampleJson = ChatSessionModel.exampleJson();
      var parse = ChatSessionModel.fromJson(exampleJson);
      final emptyShouldBeFalse = parse.match({});
      final expectedFalse = parse.match({"id":true});
      final expectedTrue = parse.match(exampleJson);
      expect(expectedTrue, true);
      expect(emptyShouldBeFalse, false);
      expect(expectedFalse, false);
    });
  });
}