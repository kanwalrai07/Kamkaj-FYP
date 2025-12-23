import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL logic
  // Android Emulator: 10.0.2.2
  // Physical Device: 192.168.1.7 (Your PC's IP)
  static String get baseUrl {
    if (Platform.isAndroid) {
      // return 'http://10.0.2.2:5000'; // USE THIS FOR EMULATOR
      return 'http://127.0.0.1:5000'; // USE THIS FOR ADB REVERSE
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

  // Generic GET request (Useful later)
  static Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(
      url,
      headers: headers,
    );
  }
}
