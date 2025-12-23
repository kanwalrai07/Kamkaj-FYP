import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'post_job_screen.dart'; // We will create this next
import '../../auth/services/auth_service.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final AuthService _authService = AuthService();

  void _logout() {
    _authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Map Placeholder (Full Screen)
          Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 50, color: Colors.grey),
                  Text("Google Map will be here"),
                ],
              ),
            ),
          ),

          // 2. Menu Button (Top Left)


          // 3. Logout Button (Top Right)
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.person, color: AppColors.secondaryBlack),
                onPressed: () {
                  Navigator.pushNamed(context, '/client-profile');
                },
              ),
            ),
          ),

          // 4. Bottom Sheet (Request Panel)
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Find a Worker",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryBlack,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Recent Placeholders
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.history, color: Colors.white),
                      ),
                      title: const Text("Fix leaking tap"),
                      subtitle: const Text("Kitchen - Yesterday"),
                      onTap: () {},
                    ),
                    const Divider(),
                    
                    const SizedBox(height: 10),
                    
                    // Request Button
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryYellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PostJobScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Request New Worker",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

    );
  }
}
