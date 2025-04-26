// User model representing the authenticated user
class User {
  final int id;
  final String username;
  final String email;

  // Constructor with named parameters for clarity
  User({
    required this.id,
    required this.username,
    required this.email,
  });

  // Factory constructor to create a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  // Convert User object to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}
