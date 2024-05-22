class User {
  final int id;
  final String email;
  final String username;
  final String password;

  User({required this.username, required this.email, required this.password, this.id = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
