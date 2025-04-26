import 'package:flutter/foundation.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Authentication service for handling user login, signup, and session management
class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get error => _error;
  
  // Constructor checks for existing session
  AuthService() {
    _checkAuthStatus();
  }
  
  // Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {

      }
    } catch (e) {
      _error = 'Failed to restore session';
      if (kDebugMode) {
        print('Auth check error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await ApiClient().post('/users/login', data: {
        'email': email,
        'password': password,
      });
      
      // Save token to shared preferences
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      // Fetch user profile
      await _fetchUserProfile();
      
      return true;
    } catch (e) {
      _error = 'Login failed. Please check your credentials.';
      if (kDebugMode) {
        print('Login error: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Register new user
  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await ApiClient().post('/users/register', data: {
        'username': username,
        'email': email,
        'password': password,
      });
      
      // Save token to shared preferences
      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      
      // Fetch user profile
      await _fetchUserProfile();

      return true;
    } catch (e) {
      _error = 'Registration failed. Please try again.';
      if (kDebugMode) {
        print('Register error: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch user profile from API
  Future<void> _fetchUserProfile() async {
    try {
      final response = await ApiClient().get('/users/profile');
      _currentUser = User.fromJson(response.data['user']);
      
    } catch (e) {
      _error = 'Failed to fetch user profile';
      if (kDebugMode) {
        print('Fetch profile error: $e');
      }
      await logout(); // Logout if profile fetch fails
    }
  }
  
  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Clear token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      
      // Clear current user
      _currentUser = null;
    } catch (e) {
      _error = 'Logout failed';
      if (kDebugMode) {
        print('Logout error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
