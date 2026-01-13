import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../jobs/services/job_service.dart';
import 'post_job_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final JobService _jobService = JobService();
  List<dynamic> _recentJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentJobs();
  }

  Future<void> _fetchRecentJobs() async {
    setState(() => _isLoading = true);
    try {
      final jobs = await _jobService.getMyJobs();
      if (mounted) {
        setState(() {
          _recentJobs = jobs; 
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      print("Error fetching recent jobs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Map Placeholder (Background)
          Container(
            color: Colors.grey[300],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Google Map will be here", style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            ),
          ),

          // 2. Profile Button (Top Right)
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

          // 3. Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.4,
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
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Draggable Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Your Job History",
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.black
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Job History List
                    Expanded(
                      child: _isLoading 
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryYellow))
                        : _recentJobs.isEmpty 
                          ? const Center(child: Text("No jobs posted yet.", style: TextStyle(color: Colors.grey)))
                          : ListView.separated(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _recentJobs.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final job = _recentJobs[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    child: const Icon(Icons.history, color: Colors.grey),
                                  ),
                                  title: Text(job['title'], style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                                  )),
                                  subtitle: Text(
                                    "${job['location'] ?? ''} • Rs. ${job['budget']}", 
                                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[700])
                                  ),
                                  trailing: Text(
                                    job['status'], 
                                    style: TextStyle(
                                      color: job['status'] == 'OPEN' ? Colors.green : Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 15),

                    // "Request New Worker" Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow,
                            foregroundColor: AppColors.secondaryBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PostJobScreen()),
                            );
                            if (result == true) {
                              _fetchRecentJobs(); // Refresh list if a new job was posted
                            }
                          },
                          child: const Text(
                            "Request New Worker",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
