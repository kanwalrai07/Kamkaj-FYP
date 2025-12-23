import 'package:flutter/material.dart';
import 'core/constants/colors.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/role_selection_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/client/screens/client_home_screen.dart';
import 'features/worker/screens/worker_home_screen.dart';
import 'features/profile/screens/client_profile_screen.dart';
import 'features/profile/screens/worker_profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const KamKajApp());
}

class KamKajApp extends StatelessWidget {
  const KamKajApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KamKaj',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryYellow,
          primary: AppColors.primaryYellow,
          secondary: AppColors.secondaryBlack,
          background: AppColors.backgroundWhite,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryYellow,
          foregroundColor: AppColors.secondaryBlack,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryYellow,
            foregroundColor: AppColors.secondaryBlack, // Text color
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/role-selection': (context) => const RoleSelectionScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/client-home': (context) => const ClientHomeScreen(),
        '/worker-home': (context) => const WorkerHomeScreen(),
        '/client-profile': (context) => const ClientProfileScreen(),
        '/worker-profile': (context) => const WorkerProfileScreen(),
      },
    );
  }
}
