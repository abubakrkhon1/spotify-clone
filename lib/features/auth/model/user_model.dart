// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String email;
  final String id;
  final String name;

  UserModel({
    required this.email,
    required this.id,
    required this.name,
  });

  UserModel copyWith({String? email, String? id, String? name}) {
    return UserModel(
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'id': id,
      'name': name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(email: $email, id: $id, name: $name)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode {
    return email.hashCode ^ id.hashCode ^ name.hashCode;
  }
}
