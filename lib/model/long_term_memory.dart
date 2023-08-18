import 'package:equatable/equatable.dart';

class LongtermMemory extends Equatable {
  LongtermMemory(
      {required this.memory,
      required this.id,
      required this.name,
      required this.vectors});

  String? id;
  String? name;
  String? memory;
  Map<String, List<double>>? vectors;

  @override
  List<Object?> get props => [id, name, vectors, memory];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'vectors': vectors, 'memory': memory};
  }

  factory LongtermMemory.fromJson(Map<String, dynamic> map) {
    return LongtermMemory(
      memory: map['memory'],
      id: map['id'],
      name: map['name'],
      vectors: map['vectors']?.map<String, List<double>>(
            (key, value) => MapEntry<String, List<double>>(
              key,
              List<double>.from(value),
            ),
          ) ??
          {},
    );
  }

  static Map<String, dynamic> exampleJson() {
    return {
      'id': "id",
      'name': "",
      'memory': "",
      'vectors': {
        '1': [1.1]
      }
    };
  }

  bool match(Map map) {
    final model = toJson();
    final keys = model.keys.toList();

    for (final query in map.entries) {
      try {
        final trueValue = model[query.key];
        final exists = trueValue == query.value;
        if (exists) {
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  static LongtermMemory example() =>
      LongtermMemory.fromJson(LongtermMemory.exampleJson());

  LongtermMemory copyWith({
    String? id,
    String? name,
    String? memory,
    Map<String, List<double>>? vectors,
  }) {
    return LongtermMemory(
      id: id ?? this.id,
      name: name ?? this.name,
      memory: memory ?? this.memory,
      vectors: vectors ?? this.vectors,
    );
  }
}

class MemoryPreview extends Equatable {
  const MemoryPreview({
    required this.memoryPreview,
    required this.id,
    required this.name,
  });

  final String? id;
  final String? name;
  final String? memoryPreview;

  @override
  List<Object?> get props => [id, name, memoryPreview];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'memory': memoryPreview};
  }

  factory MemoryPreview.fromJson(Map<String, dynamic> map) {
    return MemoryPreview(
      memoryPreview: map['memory'],
      id: map['id'],
      name: map['name'],
    );
  }

  static Map<String, dynamic> exampleJson() {
    return {
      'id': "id",
      'name': "",
      'memoryPreview': "",
    };
  }

  bool match(Map map) {
    final model = toJson();
    final keys = model.keys.toList();

    for (final query in map.entries) {
      try {
        final trueValue = model[query.key];
        final exists = trueValue == query.value;
        if (exists) {
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  static MemoryPreview example() =>
      MemoryPreview.fromJson(MemoryPreview.exampleJson());

  MemoryPreview copyWith({
    String? id,
    String? name,
    String? memoryPreview,
  }) {
    return MemoryPreview(
      id: id ?? this.id,
      name: name ?? this.name,
      memoryPreview: memoryPreview ?? this.memoryPreview,
    );
  }
}
