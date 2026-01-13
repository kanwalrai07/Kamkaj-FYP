import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/api_service.dart';
import '../../auth/services/auth_service.dart'; // To get token

class JobService {
  
  // Create a new job
  Future<void> createJob({
    required String title,
    required String description,
    required String location,
    required String category,
    required double budget,
  }) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.post(
      '/api/jobs/create',
      {
        'title': title,
        'description': description,
        'location': location,
        'category': category,
        'budget': budget,
      },
      headers: {
        'x-auth-token': token,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create job: ${response.body}');
    }
  }

  // Get jobs posted by the current client
  Future<List<dynamic>> getMyJobs() async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.get(
      '/api/jobs/client',
      headers: {
        'x-auth-token': token,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load my jobs');
    }
  }

  // Get all open jobs (For Workers)
  Future<List<dynamic>> getOpenJobs() async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.get(
      '/api/jobs/open',
      headers: {
        'x-auth-token': token,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load open jobs');
    }
  }

  // Delete Job
  Future<void> deleteJob(String jobId) async {
    try {
      final token = await AuthService().getToken();
      if (token == null) {
        throw Exception("User not authenticated");
      }

      final response = await ApiService.delete(
        "/api/jobs/$jobId",
        headers: {
          "x-auth-token": token,
        },
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw Exception(body['msg'] ?? "Failed to delete job");
      }
    } catch (e) {
      throw Exception("Error deleting job: $e");
    }
  }

  // Update Job
  Future<void> updateJob(String jobId, Map<String, dynamic> data) async {
    try {
      final token = await AuthService().getToken();
      if (token == null) {
        throw Exception("User not authenticated");
      }

      final response = await ApiService.put(
        "/api/jobs/$jobId",
        data,
        headers: {
          "x-auth-token": token,
        },
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw Exception(body['msg'] ?? "Failed to update job");
      }
    } catch (e) {
      throw Exception("Error updating job: $e");
    }
  }

  // Place Bid
  Future<void> placeBid(String jobId, double amount) async {
    final token = await AuthService().getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.post(
      '/api/jobs/$jobId/bid',
      {
        'amount': amount,
      },
      headers: {
        'x-auth-token': token,
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['msg'] ?? 'Failed to place bid');
    }
  }
}
