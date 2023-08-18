import 'package:flutter_test/flutter_test.dart';
import '../../lib/model/user.dart';

void main() async {
  group('UserModel', () {
    test('parseSample', () {
      var exampleJson = UserModel.exampleJson();
      var parse = UserModel.fromJson(exampleJson);
    });
    test('parseEmpty', () {
      var emptyWorks = UserModel.fromJson({});
    });
    test('query empty', () {
      var exampleJson = UserModel.exampleJson();
      var parse = UserModel.fromJson(exampleJson);
      final emptyShouldBeFalse = parse.match({});
      final expectedFalse = parse.match({"id":true});
      final expectedTrue = parse.match(exampleJson);
      expect(expectedTrue, true);
      expect(emptyShouldBeFalse, false);
      expect(expectedFalse, false);
    });
  });
}