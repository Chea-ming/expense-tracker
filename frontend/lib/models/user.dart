class User {
  final int id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Validate required fields
    if (!json.containsKey('id') ||
        !json.containsKey('username') ||
        !json.containsKey('email')) {
      throw Exception('Missing required fields in JSON');
    }

    // Validate field types
    if (json['id'] is! int ||
        json['username'] is! String ||
        json['email'] is! String) {
      throw Exception('Invalid field types in JSON');
    }

    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}