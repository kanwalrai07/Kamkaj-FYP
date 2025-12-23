import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/colors.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/widgets/kamkaj_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    // Check Session after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      final authService = AuthService();
      final isLoggedIn = await authService.getUserData();

      // Get user type if logged in, ensuring no async gap after mounted check
      String? userType;
      if (isLoggedIn) {
         final prefs = await SharedPreferences.getInstance();
         userType = prefs.getString('user_type');
      }

      if (mounted) {
        if (isLoggedIn) {
          // Normalize userType again just in case, though AuthService handles it
          final type = (userType ?? 'client').toLowerCase();
          
          if (type == 'client') {
            Navigator.pushReplacementNamed(context, '/client-home');
          } else {
             Navigator.pushReplacementNamed(context, '/worker-home');
          }
        } else {
          Navigator.pushReplacementNamed(context, '/role-selection');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed from primaryYellow to White for better logo visibility
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // KamKaj Logo (Using Reusable Widget)
            KamKajLogo(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
            ),
            const SizedBox(height: 20),
            // App Name
            const Text(
              'KamKaj',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryBlack,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 5),
            // Subtitle
            const Text(
              'On-Demand Worker Services',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 50),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryBlack),
            ),
          ],
        ),
      ),
    );
  }
}
