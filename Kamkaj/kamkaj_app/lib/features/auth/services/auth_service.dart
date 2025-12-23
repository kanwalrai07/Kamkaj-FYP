import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';

class AuthService {
  // Signup
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String type,
  }) async {
    try {
      final response = await ApiService.post('/api/signup', {
        'name': name,
        'email': email,
        'password': password,
        'type': type,
      });

      if (response.statusCode == 200) {
        // Registration Successful!
        // We do NOT save the token here, forcing the user to login manually.
        return;
      } else {
        // Parse error message and throw
        final body = jsonDecode(response.body);
        throw Exception(body['msg'] ?? 'Signup failed');
      }
    } catch (e) {
      // Re-throw to be handled by UI
      rethrow;
    }
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('/api/signin', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        
        // Save Token & User Data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('x-auth-token', body['token']);
        
        // Normalize role: lowercase and default to 'client'
        String userType = (body['type'] as String?)?.toLowerCase() ?? 'client';
        await prefs.setString('user_type', userType); 
        
        await prefs.setString('user_name', body['name']);
        
        return;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['msg'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Google Login
  Future<void> googleSignIn({
    required String email,
    required String name,
    required String type,
  }) async {
    try {
      final response = await ApiService.post('/api/google', {
        'email': email,
        'name': name,
        'type': type,
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        
        // Save Token & User Data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('x-auth-token', body['token']);
        
        // Normalize role
        String userType = (body['type'] as String?)?.toLowerCase() ?? 'client';
        await prefs.setString('user_type', userType); 
        
        await prefs.setString('user_name', body['name']);
        
        return;
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['msg'] ?? 'Google Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all data
  }
  // Get User Data (Session Check)
  Future<bool> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-auth-token');

      if (token == null) return false;

      // In a real app, you would call an endpoint to verify the token
      // e.g., await ApiService.post('/api/tokenIsValid', ...);
      // For now, if the token exists locally, we assume it's valid for this step
      // or we can verify it by making a dummy verified request.
      
      // OPTIONAL: Call backend to verify token validity
      /*
      final response = await ApiService.post('/api/tokenIsValid', {}, headers: {
        'x-auth-token': token,
      });
      if (response.statusCode != 200) return false;
      */

      return true;
    } catch (e) {
      return false;
    }
  }
}
