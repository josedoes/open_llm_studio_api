import 'dart:math';

import 'package:dart_openai/dart_openai.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_llm_studio_api/service/long_term_memory_service.dart';
import 'package:open_llm_studio_api/util/logging.dart';

import '../model/long_term_memory.dart';
import 'getit_injector.dart';

VectorizationService get vectorizationService => locate<VectorizationService>();

class VectorizationService {
  final tag = 'VectorizationService';
  Map<String, List<double>> agentVectors = {};

  Future<Map<String, List<double>>?> vectorizeSegments(
      List<String> segmentedData) async {
    const method = 'vectorizeSegments';
    print('$method started');
    List<OpenAIEmbeddingsDataModel> embeddedSegments = [];

    final embeddingResult = await _getOpenAiEmbeddings(segmentedData);

    if (embeddingResult.isRight) {
      print('$method _getOpenAiEmbeddings came out right');

      embeddedSegments = embeddingResult.right;

      final formatVector = _matchEmbeddingsToMetadata(
          embeddingsResult: embeddedSegments, metadata: segmentedData);
      debugPrint('$method success');

      return formatVector;
    }
    print('$method returned null');

    return null;
  }

  Map<String, List<double>>? _matchEmbeddingsToMetadata(
      {required List<String> metadata,
      required List<OpenAIEmbeddingsDataModel> embeddingsResult}) {
    const method = '_matchEmbeddingsToMetadata';
    devLog(tag: tag, message: '$method started');
    Map<String, List<double>> vectors = {};
    try {
      for (int i = 0; i < metadata.length; i++) {
        final embeddings = embeddingsResult[i].embeddings;
        vectors[metadata[i]] = embeddings;
      }
      devLog(tag: tag, message: '$method success');

      return vectors;
    } catch (e) {
      devLog(tag: tag, message: '$method exception: $e');
      return null;
    }
  }

  Future<Either<String, List<OpenAIEmbeddingsDataModel>>> _getOpenAiEmbeddings(
      List<String> input) async {
    const method = '_getOpenAiEmbeddings';
    devLog(tag: tag, message: '$method started');
    try {
      OpenAIEmbeddingsModel embeddings = await OpenAI.instance.embedding.create(
        model: "text-embedding-ada-002",
        input: input,
      );
      devLog(tag: tag, message: '$method finished');

      return Right(embeddings.data);
    } catch (e) {
      devLog(tag: tag, message: '$method exception: $e');
      return Left('');
    }
  }

  Future<Either<String, List<String>>> getRelevantMemories(
      {required String query,
      int amountOfMemoriesRetrieved = 5,
      required List<String> memoryIds}) async {
    const method = 'getSimilar';
    devLog(tag: tag, message: '$method started');

    List<MapEntry<String, double>> similarityScores = [];

    if (agentVectors.isEmpty) {
      await loadAgentVectors(memoryIds);
    }

    if (agentVectors.isNotEmpty) {
      final embeddingResult = await _getOpenAiEmbeddings([query]);

      if (embeddingResult.isRight) {
        List<double> queryVector = embeddingResult.right[0].embeddings;

        agentVectors.forEach((key, value) {
          double score = cosineSimilarity(queryVector, value);
          similarityScores.add(MapEntry(key, score));
        });

        similarityScores.sort((a, b) => b.value.compareTo(a.value));

        Map<String, List<double>> similarGuys = {};
        for (int i = 0;
            i < min(amountOfMemoriesRetrieved, similarityScores.length);
            i++) {
          similarGuys[similarityScores[i].key] =
              agentVectors[similarityScores[i].key] ?? [];
        }

        return Right([...similarGuys.keys]);
      } else {
        return Left('No vectors');
      }
    } else {
      return Left('value');
    }
  }

  Future<String?> loadAgentVectors(List<String> memoryIds) async {
    const method = 'getAgentVectors';
    devLog(tag: tag, message: '$method called');
    final result = await longTermMemoryService.readMultiple(memoryIds);
    if (result.isRight) {
      agentVectors = consolidateVectors(result.right);
      devLog(tag: tag, message: '$method success');
      return '';
    } else {
      devLog(tag: tag, message: '$method returning null');

      return null;
    }
  }

  Map<String, List<double>> consolidateVectors(List<LongtermMemory> memories) {
    Map<String, List<double>> consolidated = {};

    for (var memory in memories) {
      if (memory.vectors != null) {
        memory.vectors!.forEach((key, value) {
          if (consolidated.containsKey(key)) {
            // Append values if key exists in consolidated map
            consolidated[key]!.addAll(value);
          } else {
            // Else, create a new key-value pair
            consolidated[key] = value;
          }
        });
      }
    }

    return consolidated;
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

  Future<Either<String, List<double>>> compareAnswers(
      List<String> givenAnswers, List<String> expectedAnswers) async {
    const method = 'compareAnswers';
    devLog(tag: tag, message: '$method started');

    final List<double> scores = [];
    if (expectedAnswers.length != givenAnswers.length) {
      throw ArgumentError(
          'Expected and real answers lists have different lengths');
    }

    final givenAnswerResult =
        await vectorizationService._getOpenAiEmbeddings(givenAnswers);

    final expectedAnswerResult =
        await vectorizationService._getOpenAiEmbeddings(expectedAnswers);

    if (givenAnswerResult.isRight && expectedAnswerResult.isRight) {
      List<OpenAIEmbeddingsDataModel> givenAnswerEmbeddings =
          givenAnswerResult.right;

      List<OpenAIEmbeddingsDataModel> expectedAnswerEmbeddings =
          expectedAnswerResult.right;

      for (int i = 0; i < expectedAnswers.length; i++) {
        final expectedAnswer = expectedAnswerEmbeddings[i].embeddings;
        final givenAnswer = givenAnswerEmbeddings[i].embeddings;

        double similarityScore =
            vectorizationService.cosineSimilarity(givenAnswer, expectedAnswer);
        scores.add(similarityScore);
      }
      devLog(tag: tag, message: '$method success');

      return Right(scores);
    } else {
      devLog(tag: tag, message: '$method failed');

      return Left('');
    }
  }
}
