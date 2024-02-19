import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:get_it/get_it.dart';
import 'package:open_llm_studio_api/repository/agent_repository.dart';
import 'package:open_llm_studio_api/repository/benchmark_history_repository.dart';
import 'package:open_llm_studio_api/repository/benchmark_space_repository.dart';
import 'package:open_llm_studio_api/repository/chat_session_repository.dart';
import 'package:open_llm_studio_api/repository/llm_space_repository.dart';
import 'package:open_llm_studio_api/repository/q_a_set_repository.dart';
import 'package:open_llm_studio_api/repository/user_repository.dart';
import 'package:open_llm_studio_api/service/agent_service.dart';
import 'package:open_llm_studio_api/service/app_version/firebase_app_version_service.dart';
import 'package:open_llm_studio_api/service/benchmark_history_service.dart';
import 'package:open_llm_studio_api/service/benchmark_space_service.dart';
import 'package:open_llm_studio_api/service/chat_session_service.dart';
import 'package:open_llm_studio_api/service/firebase/firebase_service.dart';
import 'package:open_llm_studio_api/service/llm_space_service.dart';
import 'package:open_llm_studio_api/service/long_term_memory_service.dart';
import 'package:open_llm_studio_api/service/q_a_set_service.dart';
import 'package:open_llm_studio_api/service/scaffold_service.dart';
import 'package:open_llm_studio_api/service/user_service.dart';
import 'package:open_llm_studio_api/service/vectorization_service.dart';
import '../repository/benchmark_validator_repository.dart';
import '../repository/longterm_memory_preview_repository.dart';
import 'ai_service.dart';
import 'benchmark_validator_service.dart';
import 'cloud_storage_service.dart';
import 'memory_preview_service.dart';

GetIt getIt = GetIt.instance;

T locate<T extends Object>() => getIt.get<T>();

void register<T extends Object>(T obj) => getIt.registerSingleton<T>(obj);

Future<void> setUpOpenLLM({
  bool testing = false,
  required String openAiKey,
}) async {
  OpenAI.apiKey = openAiKey;

  if (testing) {
    getIt = GetIt.asNewInstance();
  }

  register(FirebaseAppVersionService());

  register(FirestoreService(firestore: FirebaseFirestore.instance));

  register(BenchmarkSpaceRepository());
  register(BenchmarkSpaceService());
  register(AiService());
  register(BenchmarkHistoryRepository());
  register(BenchmarkHistoryService());

  register(QASetRepository());
  register(QASetService());

  register(AgentRepository());
  register(AgentService());

  register(ScaffoldService());
  register(MemoryPreviewRepository());

  register(VectorizationService());
  register(LongTermMemoryService());
  register(CloudStorageService());

  register(LlmSpaceRepository());
  register(LlmSpaceService());

  register(BenchmarkValidatorRepository());
  register(BenchmarkValidatorService());

  register(MemoryPreviewService());

  register(UserModelService());
  register(UserModelRepository());

  register(ChatSessionModelService());
  register(ChatSessionModelRepository());
}
