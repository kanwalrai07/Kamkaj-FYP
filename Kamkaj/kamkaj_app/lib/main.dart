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

import 'core/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemeService().init();
  runApp(const KamKajApp());
}

class KamKajApp extends StatelessWidget {
  const KamKajApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService().themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'KamKaj',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.backgroundWhite,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryYellow,
              primary: AppColors.primaryYellow,
              secondary: AppColors.secondaryBlack,
              background: AppColors.backgroundWhite,
              brightness: Brightness.light,
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
          darkTheme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF121212), // Dark Grey
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryYellow,
              primary: AppColors.primaryYellow,
              secondary: AppColors.primaryYellow, 
              background: const Color(0xFF121212),
              brightness: Brightness.dark,
              surface: const Color(0xFF1E1E1E), 
              onSurface: Colors.white, // Ensure text on surface is white
              onBackground: Colors.white, // Ensure text on background is white
            ),
            
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F), 
              foregroundColor: AppColors.primaryYellow, 
              centerTitle: true,
              actionsIconTheme: IconThemeData(color: AppColors.primaryYellow),
            ),
            
            cardTheme: const CardThemeData(
               color: Color(0xFF1E1E1E),
               elevation: 2,
            ),
            
            iconTheme: const IconThemeData(
              color: Colors.white70,
            ),

            listTileTheme: const ListTileThemeData(
              textColor: Colors.white,
              iconColor: Colors.white70,
            ),
            
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: Colors.black, // Text remains black on yellow button
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            // Input Decoration Theme for Dark Mode
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              labelStyle: const TextStyle(color: Colors.white70),
              hintStyle: const TextStyle(color: Colors.white38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryYellow),
              ),
            ),
            
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white), // Standard text
              bodySmall: TextStyle(color: Colors.white70),
              titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              titleSmall: TextStyle(color: Colors.white),
            )
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
      },
    );
  }
}
