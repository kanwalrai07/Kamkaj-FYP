import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/profile/profile_model.dart';
import '../features/auth/services/auth_service.dart';

class ProfileService {
  static const String _profileKey = 'user_profile_data';

  // Save Profile Logic
  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(profile.toMap());
    await prefs.setString(_profileKey, jsonString);
    
    // Also sync basic data with auth prefs if needed
    if (profile.name != null) {
      await prefs.setString('user_name', profile.name!);
    }
    
    // TODO: In real app, call Backend API here to save data
    // ApiService.post('/api/profile/update', profile.toMap());
  }

  // Get Profile Logic
  Future<UserProfile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Try to get stored full profile
    String? jsonString = prefs.getString(_profileKey);
    
    if (jsonString != null) {
      return UserProfile.fromMap(jsonDecode(jsonString));
    }

    // If no full profile, create a partial one from Auth data
    // This happens on first login before profile is saved
    String? name = prefs.getString('user_name');
    String? role = prefs.getString('user_type');
    // We can't get email strictly from prefs unless we saved it during login, 
    // but we'll assume the user fills it out.
    
    return UserProfile(
      name: name ?? '',
      role: role ?? 'client',
    );
  }
  
  // Logout Helper
  Future<void> logout() async {
    final authService = AuthService();
    await authService.logout();
  }
}
