import 'package:flutter/foundation.dart';
// import 'paxckage:chatbot_demo/chatbot_demo.dart';

void devLog({
  required String tag,
  required String message,
}) {
  if (kDebugMode) {
    //print('$tag $message');
  } else {
    //print('$tag $message');
  }
}

void errorLog({
  required String tag,
  required String message,
  StackTrace? stackTrace,
}) {
  // dataDogService.logError(tag: tag, message: message, stackTrace: stackTrace);
  if (kDebugMode) {
    //print('ERROR IN $tag: $message');
  } else {
    //print('ERROR IN $tag: $message');
  }
}
