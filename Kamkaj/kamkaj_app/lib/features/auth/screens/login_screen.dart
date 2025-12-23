import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/kamkaj_logo.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/google_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  late String _role;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    _role = args != null ? args as String : 'client';
  }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Verify if the logged in user matches the selected role
      // In a real app, the role comes from the backend. 
      // Here we trust the backend token check, but for UI flow we check local match or adapt.
      final prefs = await SharedPreferences.getInstance();
      String? userType = prefs.getString('user_type');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Normalize for comparison
        final normalizedUserType = (userType ?? 'client').toLowerCase();
        final normalizedRole = _role.toLowerCase();

        if (normalizedUserType == normalizedRole) {
           Navigator.pushNamedAndRemoveUntil(
            context,
            normalizedRole == 'client' ? '/client-home' : '/worker-home',
            (route) => false,
          );
        } else {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('You logged in as a $userType, but selected $_role. Redirecting...')),
             );
             // Redirect to correct dashboard regardless of selection
             Navigator.pushNamedAndRemoveUntil(
              context,
              normalizedUserType == 'client' ? '/client-home' : '/worker-home',
              (route) => false,
            );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _role == 'client' ? 'Client Login' : 'Worker Login',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryYellow))
        : Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Center(
                child: KamKajLogo(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.width * 0.55,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryBlack,
                ),
              ),
              const Text(
                'Please sign in to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 10),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Password'),
                        content: const Text('Please contact support at support@kamkaj.com to reset your password.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.secondaryBlack),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.blue), // Using Icon as asset might be missing
                label: const Text(
                  "Sign in with Google",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                onPressed: () async {
                  try {
                    final user = await _googleAuthService.googleLogin();
                    if (user != null) {
                      await _authService.googleSignIn(
                        email: user.email ?? '',
                        name: user.displayName ?? '',
                        type: _role, // Use the selected role (client/worker)
                      );
                      
                      if (!mounted) return;
                      
                      // Normalize role for redirection
                      final normalizedRole = _role.toLowerCase();
                      
                      Navigator.pushNamedAndRemoveUntil(
                        context, 
                        normalizedRole == 'client' ? '/client-home' : '/worker-home',
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Google Sign-In Failed: $e")),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup', arguments: _role);
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.secondaryBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
