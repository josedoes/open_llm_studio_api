import 'package:open_llm_studio_api/util/extensions.dart';

double? parseDouble(dynamic entry) {
  if (entry is num) {
    return entry.toDouble();
  }
}

int? parseInt(dynamic entry) {
  if (entry is num) {
    return entry.toInt();
  }
}

num? parseNum(dynamic entry) {
  if (entry is int) {
    return parseInt(entry);
  } else if (entry is double) {
    return parseDouble(entry);
  }
  return null;
}

String? parseString(dynamic entry) => entry is String ? entry : null;

DateTime? parseDate(dynamic entry) =>
    entry is int ? entry.toDateTimeFromMilli : null;

bool? parseBool(dynamic entry) => entry is bool ? entry : null;

List<T>? parseList<T extends Object>(
    {required json, required T fromJson(item)}) {
  final items = json;
  final parsed = <T>[];
  if (items is Iterable) {
    for (final item in items) {
      parsed.add(fromJson(item));
    }
    return parsed;
  }
  return null;
}

List<T>? parsePrimitiveList<T extends Object>(data) {
  if (data is Iterable) {
    return List<T>.from(data);
  } else {
    return null;
  }
}

Map<String, V>? parseMap<V extends Object>(
    {required json, required V fromJson(json)}) {
  final map = json;
  final parsed = <String, V>{};
  if (map is Map<String, dynamic>) {
    for (final entry in map.entries) {
      parsed[entry.key] = fromJson(entry.value);
    }
    return parsed;
  }
  return null;
}

Map<String, dynamic>? valueToJson(Map<dynamic, dynamic>? map) {
  if (map == null) {
    return null;
  }
  return {
    for (var e
        in map.entries.map((e) => MapEntry(e.key.toString(), e.value.toJson())))
      e.key: e.value
  };
}

T? parseObject<T extends Object>({
  required json,
  required T Function(Map<String, dynamic> json) fromJson,
}) {
  if (json is Map) {
    return fromJson(json as Map<String, dynamic>);
  } else {
    return null;
  }
}
