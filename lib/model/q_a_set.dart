import 'package:equatable/equatable.dart';

class QASet extends Equatable {
  QASet({required this.id, required this.name, required this.backgroundKnoledge, required this.questions, required this.answers});

  final String? id;
  final String? name;
  final String? backgroundKnoledge;
  final List<String>? questions;
  final List<String>? answers;

  @override
  List<Object?> get props => [id, name, backgroundKnoledge, questions, answers];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'backgroundKnoledge': backgroundKnoledge, 'questions': questions, 'answers': answers};
  }

  factory QASet.fromJson(Map<String, dynamic> map) {
    return QASet(id: map['id'], name: map['name'], backgroundKnoledge: map['backgroundKnoledge'], questions: List<String>.from(map['questions']??[]), answers: List<String>.from(map['answers']??[]));
  }

  QASet copyWith({String? id, String? name, String? backgroundKnoledge, List<String>? questions, List<String>? answers}) {
    return QASet(id: id ?? this.id, name: name ?? this.name, backgroundKnoledge: backgroundKnoledge ?? this.backgroundKnoledge, questions: questions ?? this.questions, answers: answers ?? this.answers);
  }

 static Map<String, dynamic> exampleJson() {
    return {'id': "", 'name': "", 'backgroundKnoledge': "", 'questions': ['example'], 'answers': ['example']};
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

static QASet example()=> QASet.fromJson(QASet.exampleJson());}
