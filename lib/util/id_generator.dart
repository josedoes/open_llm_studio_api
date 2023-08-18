import 'package:uuid/uuid.dart';

final uuid = Uuid();
String  newId() => uuid.v4();