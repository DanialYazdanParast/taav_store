class CreateUserDto {
  final String username;
  final String password;
  final String userType;

  CreateUserDto({
    required this.username,
    required this.password,
    required this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'userType': userType,
    };
  }

}
