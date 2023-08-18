import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../util/logging.dart';
import '../getit_injector.dart';

FirebaseAppVersionService get firebaseAppVersionService =>
    locate<FirebaseAppVersionService>();

class FirebaseAppVersionService {
  final tag = "FirebaseAppVersion";

  FirebaseDatabase get db => FirebaseDatabase.instance;

  DatabaseReference get _appVersion => db.ref().child('appVersion');

  Future<String> firebaseAppVersion() async {
    try {
      devLog(tag: tag, message: 'fetching appVersion on ${_appVersion.path}');
      final result = await _appVersion.get();
      final String version = result.value as String;

      if (version != null) {
        return version;
      } else {
        if (kDebugMode) {
          throw Exception('firebase response null for app version');
        }

        errorLog(tag: 'AppVersionService', message: 'error fetching version');
        return '0.0.0';
      }
    } catch (e) {
      errorLog(tag: 'AppVersionService', message: '$e');
    }
    return '0.0.0';
  }
}

// Future<String> setupRemoteConfig() async {
//   try {
//     final remoteConfig = FirebaseRemoteConfig.instance;
//     await remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(minutes: 1),
//       minimumFetchInterval: const Duration(hours: 1),
//     ));
//     await remoteConfig.fetchAndActivate();
//     final String versionNumber = remoteConfig.getString('appVersion');
//     return versionNumber;
//   }catch(e){
//      devLog(tag: tag, message:tag:tag, message:'RemoteConfigService error: $e');
//     return '10.0.0';
//   }
// }
