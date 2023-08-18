import 'package:equatable/equatable.dart';

class Question extends Equatable {
  Question({required this.id, required this.question, required this.expectedAnswer});

  final String? id;
  final String? question;
  final String? expectedAnswer;

  @override
  List<Object?> get props => [id, question, expectedAnswer];

  Map<String, dynamic> toJson() {
    return {'id': id, 'question': question, 'expectedAnswer': expectedAnswer};
  }

  factory Question.fromJson(Map<String, dynamic> map) {
    return Question(id: map['id'], question: map['question'], expectedAnswer: map['expectedAnswer']);
  }

  Question copyWith({String? id, String? question, String? expectedAnswer}) {
    return Question(id: id ?? this.id, question: question ?? this.question, expectedAnswer: expectedAnswer ?? this.expectedAnswer);
  }

 static Map<String, dynamic> exampleJson() {
    return {'id': "", 'question': "", 'expectedAnswer': ""};
  }
}
