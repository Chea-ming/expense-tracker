import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/user.dart';

void main() {
  group('User', () {
    // Sample valid JSON for testing
    final validJson = {
      'id': 1,
      'username': 'testuser',
      'email': 'test@example.com',
    };

    // Sample User instance for testing
    final validUser = User(
      id: 1,
      username: 'testuser',
      email: 'test@example.com',
    );

    test('should create User instance with valid data', () {
      // Arrange: Create a User instance
      final user = User(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
      );

      // Assert: Verify all fields are set correctly
      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
    });

    test('fromJson should parse valid JSON correctly', () {
      // Act: Parse JSON into User
      final user = User.fromJson(validJson);

      // Assert: Verify parsed fields match expected values
      expect(user.id, validJson['id']);
      expect(user.username, validJson['username']);
      expect(user.email, validJson['email']);
    });

    test('fromJson should throw Exception for missing required fields', () {
      // Arrange: JSON missing 'email' and 'token'
      final invalidJson = {
        'id': 1,
        'username': 'testuser',
      };

      // Assert: Expect an Exception due to missing fields
      expect(() => User.fromJson(invalidJson), throwsException);
    });

    test('fromJson should handle non-integer id by throwing Exception', () {
      // Arrange: JSON with invalid 'id' type
      final invalidJson = {
        'id': 'not_an_integer',
        'username': 'testuser',
        'email': 'test@example.com',
      };

      // Assert: Expect an Exception due to invalid id type
      expect(() => User.fromJson(invalidJson), throwsException);
    });

    test('toJson should serialize User to correct JSON map', () {
      // Act: Convert User to JSON
      final json = validUser.toJson();

      // Assert: Verify JSON matches expected structure
      expect(json, validJson);
      expect(json['id'], 1);
      expect(json['username'], 'testuser');
      expect(json['email'], 'test@example.com');
    });

    test('toJson and fromJson should be reversible', () {
      // Act: Serialize to JSON and parse back to User
      final json = validUser.toJson();
      final parsedUser = User.fromJson(json);

      // Assert: Verify parsed User matches original
      expect(parsedUser.id, validUser.id);
      expect(parsedUser.username, validUser.username);
      expect(parsedUser.email, validUser.email);
    });

    test('fromJson should throw Exception for null values in required fields',
        () {
      // Arrange: JSON with null values for required fields
      final invalidJson = {
        'id': null,
        'username': null,
        'email': null,
      };

      // Assert: Expect an Exception due to null values
      expect(() => User.fromJson(invalidJson), throwsException);
    });
  });
}
