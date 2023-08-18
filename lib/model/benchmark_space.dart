import 'package:equatable/equatable.dart';
import 'package:open_llm_studio_api/model/agent.dart';
import 'package:open_llm_studio_api/model/q_a_set.dart';

class BenchmarkSpaceOld extends Equatable {
  BenchmarkSpaceOld({required this.id, required this.name, required this.agent, required this.qaSet});

  final String? id;
  final String? name;
  final Agent? agent;
  final QASet? qaSet;

  @override
  List<Object?> get props => [id, name, agent, qaSet];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'agent': agent?.toJson(), 'qaSet': qaSet?.toJson()};
  }

  factory BenchmarkSpaceOld.fromJson(Map<String, dynamic> map) {
    return BenchmarkSpaceOld(id: map['id'], name: map['name'], agent: Agent.fromJson(map['agent']??{}), qaSet: QASet.fromJson(map['qaSet']??{}));
  }

  BenchmarkSpaceOld copyWith({String? id, String? name, Agent? agent, QASet? qaSet}) {
    return BenchmarkSpaceOld(id: id ?? this.id, name: name ?? this.name, agent: agent ?? this.agent, qaSet: qaSet ?? this.qaSet);
  }

 static Map<String, dynamic> exampleJson() {
    return {'id': "", 'name': "", 'agent': Agent.exampleJson(), 'qaSet': QASet.exampleJson()};
  }
}

