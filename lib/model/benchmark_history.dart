import 'package:equatable/equatable.dart';

class BenchmarkHistory extends Equatable {
  BenchmarkHistory({required this.id, required this.uid, required this.spaceId, required this.prompt, required this.benchmarkPrompt, required this.modelUsed, required this.firestoreDocumentId, required this.validatorRules, required this.totalTrueByHuman, required this.millisecondsRun, required this.tokens, required this.approximatePrice, required this.date, required this.totalQuestions, required this.totalMissed, required this.totalTrue});

  final String? id;
  final String? uid;
  final String? spaceId;
  final String? prompt;
  final String? benchmarkPrompt;
  final String? modelUsed;
  final String? firestoreDocumentId;
  final String? validatorRules;
  final int? totalTrueByHuman;
  final int? millisecondsRun;
  final int? tokens;
  final int? approximatePrice;
  final int? date;
  final int? totalQuestions;
  final int? totalMissed;
  final int? totalTrue;

  @override
  List<Object?> get props => [id, uid, spaceId, prompt, benchmarkPrompt, modelUsed, firestoreDocumentId, validatorRules, totalTrueByHuman, millisecondsRun, tokens, approximatePrice, date, totalQuestions, totalMissed, totalTrue];

  Map<String, dynamic> toJson() {
    return {'id': id, 'uid': uid, 'spaceId': spaceId, 'prompt': prompt, 'benchmarkPrompt': benchmarkPrompt, 'modelUsed': modelUsed, 'firestoreDocumentId': firestoreDocumentId, 'validatorRules': validatorRules, 'totalTrueByHuman': totalTrueByHuman, 'millisecondsRun': millisecondsRun, 'tokens': tokens, 'approximatePrice': approximatePrice, 'date': date, 'totalQuestions': totalQuestions, 'totalMissed': totalMissed, 'totalTrue': totalTrue};
  }

  factory BenchmarkHistory.fromJson(Map<String, dynamic> map) {
    return BenchmarkHistory(id: map['id'], uid: map['uid'], spaceId: map['spaceId'], prompt: map['prompt'], benchmarkPrompt: map['benchmarkPrompt'], modelUsed: map['modelUsed'], firestoreDocumentId: map['firestoreDocumentId'], validatorRules: map['validatorRules'], totalTrueByHuman: map['totalTrueByHuman'], millisecondsRun: map['millisecondsRun'], tokens: map['tokens'], approximatePrice: map['approximatePrice'], date: map['date'], totalQuestions: map['totalQuestions'], totalMissed: map['totalMissed'], totalTrue: map['totalTrue']);
  }

  BenchmarkHistory copyWith({String? id, String? uid, String? spaceId, String? prompt, String? benchmarkPrompt, String? modelUsed, String? firestoreDocumentId, String? validatorRules, int? totalTrueByHuman, int? millisecondsRun, int? tokens, int? approximatePrice, int? date, int? totalQuestions, int? totalMissed, int? totalTrue}) {
    return BenchmarkHistory(id: id ?? this.id, uid: uid ?? this.uid, spaceId: spaceId ?? this.spaceId, prompt: prompt ?? this.prompt, benchmarkPrompt: benchmarkPrompt ?? this.benchmarkPrompt, modelUsed: modelUsed ?? this.modelUsed, firestoreDocumentId: firestoreDocumentId ?? this.firestoreDocumentId, validatorRules: validatorRules ?? this.validatorRules, totalTrueByHuman: totalTrueByHuman ?? this.totalTrueByHuman, millisecondsRun: millisecondsRun ?? this.millisecondsRun, tokens: tokens ?? this.tokens, approximatePrice: approximatePrice ?? this.approximatePrice, date: date ?? this.date, totalQuestions: totalQuestions ?? this.totalQuestions, totalMissed: totalMissed ?? this.totalMissed, totalTrue: totalTrue ?? this.totalTrue);
  }

 static Map<String, dynamic> exampleJson() {
    return {'id': "", 'uid': "", 'spaceId': "", 'prompt': "", 'benchmarkPrompt': "", 'modelUsed': "", 'firestoreDocumentId': "", 'validatorRules': "", 'totalTrueByHuman': 0, 'millisecondsRun': 0, 'tokens': 0, 'approximatePrice': 0, 'date': 0, 'totalQuestions': 0, 'totalMissed': 0, 'totalTrue': 0};
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

static BenchmarkHistory example()=> BenchmarkHistory.fromJson(BenchmarkHistory.exampleJson());}
