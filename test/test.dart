// main() async {
//   OpenAI.apiKey = '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';
//   TestWidgetsFlutterBinding.ensureInitialized();
//   group('Test Service', () {
//     test('description', () async {
//       final service = VectorizationService();
//       await service.vectorize(
//           text: story, segmentBy: SegmentBy.sentences, wordsPerChonk: null);
//       final result = await service.getSimilar(query: 'who is shrek');
//       for (final i in result) {
//         //print(i);
//       }
//       expect(result, result.isNotEmpty);
//     });
//   });
// }
