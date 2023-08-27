import 'dart:convert';
import 'dart:math';
import 'package:dart_openai/dart_openai.dart';
import 'package:open_llm_studio_api/util/logging.dart';
import 'package:llm_chat/model/llm_chat_message.dart';
import 'getit_injector.dart';

AiService get aiService => locate<AiService>();

OpenAIChatCompletionChoiceMessageModel systemMessage(String content) {
  return OpenAIChatCompletionChoiceMessageModel(
      content: content, role: OpenAIChatMessageRole.system);
}

OpenAIChatCompletionChoiceMessageModel userMessage(String content) {
  return OpenAIChatCompletionChoiceMessageModel(
      content: content, role: OpenAIChatMessageRole.user);
}

class AiService {
  final tag = 'AiService';

  int countStringTokens(String str) {
    List<String> tokens = str.split(' ');
    return tokens.length;
  }

  Future<String?> sendPromptGPT3turbo16k(String prompt,
      {double? temperature}) async {
    try {
      final allocatedResponseTokens = 14000 - countStringTokens(prompt);

      OpenAIChatCompletionModel chatCompletion =
          await OpenAI.instance.chat.create(
        maxTokens: allocatedResponseTokens,
        temperature: temperature ?? 0.0,
        model: "gpt-3.5-turbo-16k",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: prompt,
            role: OpenAIChatMessageRole.system,
          ),
        ],
      );
      return chatCompletion.choices.first.message.content;
    } catch (e) {
      print("Error with GPT3Turbo chat completion: $e");
      return null;
    }
  }

  Future<String?> chatWithGPT({
    String model = "gpt-3.5-turbo-16k",
    required List<OpenAIChatCompletionChoiceMessageModel> chat,
  }) async {
    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: model,
        messages: chat,
      );
      return chatCompletion.choices.first.message.content;
    } catch (e) {
      devLog(tag: tag, message: "Error with GPT3Turbo chat completion: $e");
      return null;
    }
  }

  Future<String?> chatWithGPT16k(
      {String model = "gpt-3.5-turbo-16k",
      required List<LlmChatMessage> chat}) async {
    try {
      List<OpenAIChatCompletionChoiceMessageModel> messages = [];
      for (final m in chat) {
        messages.add(OpenAIChatCompletionChoiceMessageModel(
            content: m.message ?? 'theres been an error',
            role: OpenAIChatMessageRole.values
                .firstWhere((e) => e.name == m.type)));
      }

      final chatCompletion = await OpenAI.instance.chat.create(
        model: model,
        messages: messages,
      );
      return chatCompletion.choices.first.message.content;
    } catch (e) {
      devLog(tag: tag, message: "Error with GPT3Turbo chat completion: $e");
      return null;
    }
  }

  Future<Map<String, String>> generateQASet({
    required String? data,
    required Map<String, String> questionAndAnswer,
    required int number,
  }) async {
    devLog(tag: tag, message: 'generateQASet');

    final map = questionAndAnswer.map((key, value) {
      if (value.isEmpty) {
        return MapEntry(key, '[Create Answer Here]');
      } else {
        return MapEntry(key, value);
      }
    });

    String prefice =
        "Hello Thank you for to be a QA Json generator! We are going to generate a map {\"question\":\"answer\"} These questions will be used to quiz our representative who might be asked all sorts fo things by the public."
        "Please reply back with a Json object only, make sure it only has ${number} of entries";

    String dataPrompt = data != null
        ? 'Here is some background info about the dataset!: \n$data'
        : '';

    String questionPrompt =
        'You will have to generate Questions and Answers to suplement what I already have. Here is what I am working with at the moment:\n$map\n\n';

    String requestPrompt =
        'Please choose intelligent well rounded questions meant to test my agents knowledge and please reply with only the completed valid JsonFormat response';

    String prompt = '$prefice\n\n$dataPrompt\n$questionPrompt\n$requestPrompt';

    final response = await sendPromptGPT3turbo16k(prompt);
    try {
      if (response != null) {
        final decoded = jsonDecode(response);
        final newMap = <String, String>{};
        var myList = Map.from(decoded);
        for (final entry in myList.entries) {
          newMap[entry.key.toString()] = entry.value.toString();
        }
        return newMap;
      } else {
        return {};
      }
    } catch (e) {
      print('error $e');
    }
    return {};
  }

  Future<List<double>> compareAnswers(
      List<String> givenAnswers, List<String> expectedAnswers) async {
    final List<double> scores = [];
    if (expectedAnswers.length != givenAnswers.length) {
      throw ArgumentError(
          'Expected and real answers lists have different lengths');
    }

    List<OpenAIEmbeddingsDataModel> givenAnswerEmbeddings =
        await getOpenAiEmbeddings(givenAnswers);

    List<OpenAIEmbeddingsDataModel> expectedAnswerEmbeddings =
        await getOpenAiEmbeddings(expectedAnswers);

    for (int i = 0; i < expectedAnswers.length; i++) {
      final expectedAnswer = expectedAnswerEmbeddings[i].embeddings;
      final givenAnswer = givenAnswerEmbeddings[i].embeddings;

      double similarityScore = cosineSimilarity(givenAnswer, expectedAnswer);
      scores.add(similarityScore);
    }
    return scores;
  }

  double cosineSimilarity(List<double> vectorA, List<double> vectorB) {
    if (vectorA.length != vectorB.length) {
      throw ArgumentError('Vectors must have the same dimension');
    }

    var dotProduct = 0.0;
    var magnitudeA = 0.0;
    var magnitudeB = 0.0;

    for (var i = 0; i < vectorA.length; i++) {
      dotProduct += vectorA[i] * vectorB[i];
      magnitudeA += pow(vectorA[i], 2);
      magnitudeB += pow(vectorB[i], 2);
    }

    magnitudeA = sqrt(magnitudeA);
    magnitudeB = sqrt(magnitudeB);

    if (magnitudeA == 0.0 || magnitudeB == 0.0) {
      return 0.0;
    } else {
      return dotProduct / (magnitudeA * magnitudeB);
    }
  }

  Future<List<OpenAIEmbeddingsDataModel>> getOpenAiEmbeddings(
    List<String> input,
  ) async {
    OpenAIEmbeddingsModel embeddings = await OpenAI.instance.embedding.create(
      model: "text-embedding-ada-002",
      input: input,
    );

    return embeddings.data;
  }
}
