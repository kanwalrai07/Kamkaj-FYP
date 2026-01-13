import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL logic
  // Android Emulator: 10.0.2.2
  // Physical Device: 192.168.1.7 (Your PC's IP)
  static String get baseUrl {
    if (Platform.isAndroid) {
      // return 'http://10.0.2.2:5000'; // FOR EMULATOR
      return 'http://10.113.134.32:5000'; // FOR PHYSICAL DEVICE
    } else {
      return 'http://localhost:5000';
    }
  }

  // Generic POST request
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('ApiService: POSTing to $url'); // Debug Log
    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          ...?headers,
        },
      ).timeout(const Duration(seconds: 10)); // 10s Timeout
      print('ApiService: Response ${response.statusCode}'); // Debug Log
      return response;
    } catch (e) {
      print('ApiService: Error connecting to $url'); // Debug Log
      print('ApiService: Exception details: $e'); // Debug Log
      throw Exception('Connection failed: $e');
    }
  }

  // Generic PUT request
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('ApiService: PUT request to $url');
    try {
      final response = await http.put(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          ...?headers,
        },
      ).timeout(const Duration(seconds: 10));
      print('ApiService: Response ${response.statusCode}');
      return response;
    } catch (e) {
      print('ApiService: Error connecting to $url');
      throw Exception('Connection failed: $e');
    }
  }

  // Generic DELETE request
  static Future<http.Response> delete(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('ApiService: DELETE request to $url');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          ...?headers,
        },
      ).timeout(const Duration(seconds: 10));
      print('ApiService: Response ${response.statusCode}');
      return response;
    } catch (e) {
      print('ApiService: Error connecting to $url');
      throw Exception('Connection failed: $e');
    }
  }

  // Generic GET request (Useful later)
  static Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(
      url,
      headers: headers,
    );
  }
}
