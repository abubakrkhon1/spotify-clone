import 'dart:convert';

class UserModel {
  final String email;
  final String id;

  UserModel({
    required this.email,
    required this.id,
  });

  UserModel copyWith({
    String? email,
    String? id,
  }) {
    return UserModel(
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserModel(email: $email, id: $id)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.id == id;
  }

  @override
  int get hashCode => email.hashCode ^ id.hashCode;
}
