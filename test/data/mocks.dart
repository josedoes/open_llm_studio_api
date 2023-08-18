import 'package:open_llm_studio_api/service/cloud_storage_service.dart';
import 'package:open_llm_studio_api/service/firebase/firebase_service.dart';
import 'package:open_llm_studio_api/service/getit_injector.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestoreService extends Mock implements FirestoreService {
  MockFirestoreService() {
    register<FirestoreService>(this);
  }
}

class MockCloudStorageService extends Mock implements CloudStorageService {
  MockCloudStorageService() {
    register<CloudStorageService>(this);
  }
}
