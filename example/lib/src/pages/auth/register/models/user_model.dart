
class UserModel {
  final String id;
  final String username;
  final String? password;
  final String userType;

  UserModel({
    required this.id,
    required this.username,
    this.password,
    required this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      password: json['password'],
      userType: json['userType'] ?? '',
    );
  }

 

  bool get isBuyer => userType == 'buyer';

  bool get isSeller => userType == 'seller';

  @override
  String toString() =>
      'UserModel(id: $id, username: $username, userType: $userType)';
}
