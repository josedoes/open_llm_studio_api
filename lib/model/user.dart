import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  UserModel(
      {required this.id,
      required this.email,
      required this.openaiKey,
      required this.apiCount,
      required this.totalPrice});

  final String? id;
  final String? email;
  final String? openaiKey;
  final int? apiCount;
  final double? totalPrice;

  @override
  List<Object?> get props => [id, email, openaiKey, apiCount, totalPrice];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'openaiKey': openaiKey,
      'apiCount': apiCount,
      'totalPrice': totalPrice
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        email: map['email'],
        openaiKey: map['openaiKey'],
        apiCount: map['apiCount'],
        totalPrice: map['totalPrice']);
  }

  UserModel copyWith(
      {String? id,
      String? email,
      String? openaiKey,
      int? apiCount,
      double? totalPrice}) {
    return UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        openaiKey: openaiKey ?? this.openaiKey,
        apiCount: apiCount ?? this.apiCount,
        totalPrice: totalPrice ?? this.totalPrice);
  }

  static Map<String, dynamic> exampleJson() {
    return {
      'id': "",
      'email': "",
      'openaiKey': "",
      'apiCount': 0,
      'totalPrice': 0.0
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

  static UserModel example() => UserModel.fromJson(UserModel.exampleJson());
}
