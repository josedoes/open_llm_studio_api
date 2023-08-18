import 'package:equatable/equatable.dart';

class Agent extends Equatable {
  Agent(
      {required this.id,
      required this.name,
      required this.prompt,
      required this.longTermMemoryIds,
      required this.preferedModel});

  final String? id;
  final String? name;
  final String? prompt;
  final List<String>? longTermMemoryIds;
  final LLmModel? preferedModel;

  @override
  List<Object?> get props =>
      [id, name, prompt, longTermMemoryIds, preferedModel];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'prompt': prompt,
      'longTermMemoryIds': longTermMemoryIds,
      'preferedModel': preferedModel?.toJson()
    };
  }

  factory Agent.fromJson(Map<String, dynamic> map) {
    return Agent(
        id: map['id'],
        name: map['name'],
        prompt: map['prompt'],
        longTermMemoryIds: List<String>.from(map['longTermMemoryIds'] ?? []),
        preferedModel: LLmModel.fromJson(map['preferedModel'] ?? {}));
  }

  Agent copyWith(
      {String? id,
      String? name,
      String? prompt,
      List<String>? longTermMemoryIds,
      LLmModel? preferedModel}) {
    return Agent(
        id: id ?? this.id,
        name: name ?? this.name,
        prompt: prompt ?? this.prompt,
        longTermMemoryIds: longTermMemoryIds ?? this.longTermMemoryIds,
        preferedModel: preferedModel ?? this.preferedModel);
  }

  static Map<String, dynamic> exampleJson() {
    return {
      'id': "",
      'name': "",
      'prompt': "",
      'longTermMemoryIds': ['example'],
      'preferedModel': LLmModel.exampleJson()
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

  static Agent example() => Agent.fromJson(Agent.exampleJson());
}

class LLmModel extends Equatable {
  LLmModel(
      {required this.id, required this.companyName, required this.modelName});

  final String? id;
  final String? companyName;
  final String? modelName;

  @override
  List<Object?> get props => [id, companyName, modelName];

  Map<String, dynamic> toJson() {
    return {'id': id, 'companyName': companyName, 'modelName': modelName};
  }

  factory LLmModel.fromJson(Map<String, dynamic> map) {
    return LLmModel(
        id: map['id'],
        companyName: map['companyName'],
        modelName: map['modelName']);
  }

  LLmModel copyWith({String? id, String? companyName, String? modelName}) {
    return LLmModel(
        id: id ?? this.id,
        companyName: companyName ?? this.companyName,
        modelName: modelName ?? this.modelName);
  }

  static Map<String, dynamic> exampleJson() {
    return {'id': "", 'companyName': "", 'modelName': ""};
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

  static LLmModel example() => LLmModel.fromJson(LLmModel.exampleJson());
}
