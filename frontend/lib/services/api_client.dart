import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// API client for handling all HTTP requests
class ApiClient {
  late Dio _dio;
  
  // Base URL for the API - replace with your actual backend URL
  static const String baseUrl = 'http://localhost:3001/api';
  
  // Singleton pattern for ApiClient
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() => _instance;
  
  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
    ));
    
    // Add interceptor for authentication token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get token from shared preferences
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        
        // Add token to headers if available
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        // Handle 401 Unauthorized errors
        if (error.response?.statusCode == 401) {
          // TODO: Could refresh token or redirect to login
        }
        return handler.next(error);
      },
    ));
  }

  // Set the Dio instance (for testing purposes)
  set dio(Dio dio) {
    _dio = dio;
  }
  
  // GET request method
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }
  
  // POST request method
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
  
  // PUT request method
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
  
  // DELETE request method
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      rethrow;
    }
  }
}
