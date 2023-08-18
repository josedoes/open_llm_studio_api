import 'package:equatable/equatable.dart';

import '../util/parsing.dart';

class ChatSessionModel extends Equatable {
  ChatSessionModel(
      {required this.id,
      required this.userId,
      required this.agentId,
      required this.startTime,
      required this.endTime,
      required this.messages});

  final String? id;
  final String? userId;
  final String? agentId;
  final String? startTime;
  final String? endTime;
  final List<ChatMessage>? messages;

  @override
  List<Object?> get props =>
      [id, userId, agentId, startTime, endTime, messages];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'agentId': agentId,
      'startTime': startTime,
      'endTime': endTime,
      'messages': messages?.map((e) => e.toJson()).toList()
    };
  }

  factory ChatSessionModel.fromJson(Map<String, dynamic> map) {
    return ChatSessionModel(
      id: map['id'],
      userId: map['userId'],
      agentId: map['agentId'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      messages: parseList<ChatMessage>(
        json: map['messages'],
        fromJson: (a) => ChatMessage.fromJson(a),
      ),
    );
  }

  ChatSessionModel copyWith(
      {String? id,
      String? userId,
      String? agentId,
      String? startTime,
      String? endTime,
      List<ChatMessage>? messages}) {
    return ChatSessionModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        agentId: agentId ?? this.agentId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        messages: messages ?? this.messages);
  }

  static Map<String, dynamic> exampleJson() {
    return {
      'id': "",
      'userId': "",
      'agentId': "",
      'startTime': "",
      'endTime': "",
      'messages': [
        ChatMessage.exampleJson(),
      ]
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

  static ChatSessionModel example() =>
      ChatSessionModel.fromJson(ChatSessionModel.exampleJson());
}

class ChatMessage extends Equatable {
  ChatMessage(
      {required this.id,
      required this.text,
      required this.sender,
      required this.sessionId,
      required this.timestamp});

  final String? id;
  final String? text;
  final String? sender;
  final String? sessionId;
  final String? timestamp;

  @override
  List<Object?> get props => [id, text, sender, sessionId, timestamp];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender': sender,
      'sessionId': sessionId,
      'timestamp': timestamp
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> map) {
    return ChatMessage(
        id: map['id'],
        text: map['text'],
        sender: map['sender'],
        sessionId: map['sessionId'],
        timestamp: map['timestamp']);
  }

  ChatMessage copyWith(
      {String? id,
      String? text,
      String? sender,
      String? senderId,
      String? sessionId,
      String? timestamp}) {
    return ChatMessage(
        id: id ?? this.id,
        text: text ?? this.text,
        sender: sender ?? this.sender,
        sessionId: sessionId ?? this.sessionId,
        timestamp: timestamp ?? this.timestamp);
  }

  static Map<String, dynamic> exampleJson() {
    return {
      'id': "",
      'text': "",
      'sender': "",
      'senderId': "",
      'sessionId': "",
      'timestamp': ""
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

  static ChatMessage example() =>
      ChatMessage.fromJson(ChatMessage.exampleJson());
}
