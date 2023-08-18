import 'package:equatable/equatable.dart';

class LlmSpace extends Equatable {
  LlmSpace({required this.id, required this.name, required this.agentId, required this.qaSetId, required this.validatorId});

  final String? id;
  final String? name;
  final String? agentId;
  final String? qaSetId;
  final String? validatorId;

  @override
  List<Object?> get props => [id, name, agentId, qaSetId, validatorId];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'agentId': agentId, 'qaSetId': qaSetId, 'validatorId': validatorId};
  }

  factory LlmSpace.fromJson(Map<String, dynamic> map) {
    return LlmSpace(id: map['id'], name: map['name'], agentId: map['agentId'], qaSetId: map['qaSetId'], validatorId: map['validatorId']);
  }

  LlmSpace copyWith({String? id, String? name, String? agentId, String? qaSetId, String? validatorId}) {
    return LlmSpace(id: id ?? this.id, name: name ?? this.name, agentId: agentId ?? this.agentId, qaSetId: qaSetId ?? this.qaSetId, validatorId: validatorId ?? this.validatorId);
  }

 static Map<String, dynamic> exampleJson() {
    return {'id': "", 'name': "", 'agentId': "", 'qaSetId': "", 'validatorId': ""};
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

static LlmSpace example()=> LlmSpace.fromJson(LlmSpace.exampleJson());}
