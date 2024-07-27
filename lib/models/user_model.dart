class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? number;
  String? avatar;
  String? role;
  DateTime? createdAt;

  UserModel(
      {this.firstName,
        this.lastName,
        this.email,
        this.number,
        this.avatar,
        this.role,
        this.createdAt});

  UserModel.fromJson(Map<String, dynamic> user) {
    firstName = user['firstName'] as String?;
    lastName = user['lastName'] as String?;
    email = user['email'] as String?;
    number = user['number'] as String?;
    avatar = user['avatar'] as String?;
    role = user['role'] as String?;
    createdAt = user['createdAt'] != null
        ? DateTime.parse(user['createdAt'] as String)
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'number': number,
      'avatar': avatar,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
