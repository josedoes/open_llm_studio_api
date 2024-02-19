import 'package:flutter/foundation.dart';

Function(String log) onDevLogLog = (a) {};
Function(String log) onErrorLog = (a) {};

void devLog({
  required String tag,
  required String message,
}) {
  onDevLogLog('$tag $message');
  if (kDebugMode) {
    //print();
  } else {
    //print('$tag $message');
  }
}

void errorLog({
  required String tag,
  required String message,
  StackTrace? stackTrace,
}) {
  onErrorLog('ERROR: ${tag}: $message \n\n${stackTrace}');
  // dataDogService.logError(tag: tag, message: message, stackTrace: stackTrace);
  if (kDebugMode) {
    //print('ERROR IN $tag: $message');
  } else {
    //print('ERROR IN $tag: $message');
  }
}
