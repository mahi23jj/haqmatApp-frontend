class AuthModel {
  final String token;
  final String userId;
  final String name;
  final String email;

  AuthModel({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
  });

  // from json
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      name: json['user']['name'],
      userId: json['user']['id'],
      email: json['user']['email'],
    );
  }
}


//^.*phoneNumber.*\n?