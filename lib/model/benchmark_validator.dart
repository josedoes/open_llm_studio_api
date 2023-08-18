import 'package:equatable/equatable.dart';
import 'package:open_llm_studio_api/model/agent.dart';

class BenchmarkValidator extends Equatable {
  BenchmarkValidator({required this.id, required this.name, required this.prompt, required this.longTermMemoryIds, required this.preferedModel});

  final String? id;
  final String? name;
  final String? prompt;
  final List<String>? longTermMemoryIds;
  final LLmModel? preferedModel;

  @override
  List<Object?> get props => [id, name, prompt, longTermMemoryIds, preferedModel];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'prompt': prompt, 'longTermMemoryIds': longTermMemoryIds, 'preferedModel': preferedModel?.toJson()};
  }

  factory BenchmarkValidator.fromJson(Map<String, dynamic> map) {
    return BenchmarkValidator(id: map['id'], name: map['name'], prompt: map['prompt'], longTermMemoryIds: List<String>.from(map['longTermMemoryIds']??[]), preferedModel: LLmModel.fromJson(map['preferedModel']??{}));
  }

  BenchmarkValidator copyWith({String? id, String? name, String? prompt, List<String>? longTermMemoryIds, LLmModel? preferedModel}) {
    return BenchmarkValidator(id: id ?? this.id, name: name ?? this.name, prompt: prompt ?? this.prompt, longTermMemoryIds: longTermMemoryIds ?? this.longTermMemoryIds, preferedModel: preferedModel ?? this.preferedModel);
  }

 static Map<String, dynamic> exampleJson() {
    return {'id': "", 'name': "", 'prompt': "", 'longTermMemoryIds': ['example'], 'preferedModel': LLmModel.exampleJson()};
  }
bool match(Map map){
    final model = toJson();
    final keys = model.keys.toList();
    
    for(final query in map.entries){
      try{
        final trueValue = model[query.key];
        final exists  = trueValue == query.value;
        if(exists){
          return true;
        }
      }catch(e){
        return false;
      }
    }
    return false;
}

static BenchmarkValidator example()=> BenchmarkValidator.fromJson(BenchmarkValidator.exampleJson());}
