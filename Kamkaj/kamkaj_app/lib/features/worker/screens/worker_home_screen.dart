import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../auth/services/auth_service.dart';
import 'job_detail_screen.dart';
import 'assigned_jobs_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  final AuthService _authService = AuthService();
  bool _isOnline = false;

  final List<Map<String, dynamic>> _dummyJobs = [
    {
      'title': 'Fan Installation',
      'address': 'Johar Town, Block G',
      'budget': 'Rs. 800',
      'distance': '2.5 km',
      'category': 'Electrician'
    },
    {
      'title': 'Kitchen Tap Fix',
      'address': 'Wapda Town',
      'budget': 'Rs. 1200',
      'distance': '4.1 km',
      'category': 'Plumber'
    },
    {
      'title': 'Wood Polish',
      'address': 'Model Town',
      'budget': 'Rs. 5000',
      'distance': '6.0 km',
      'category': 'Carpenter'
    },
  ];

  void _logout() {
    _authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Worker Dashboard'),
          backgroundColor: AppColors.primaryYellow,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.person), 
              onPressed: () {
                Navigator.pushNamed(context, '/worker-profile');
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: "New Jobs"),
              Tab(text: "Assigned Jobs"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: New Jobs
            Column(
              children: [
                // Status Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: _isOnline ? Colors.green[100] : Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isOnline ? "You are ONLINE" : "You are OFFLINE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isOnline ? Colors.green : Colors.grey,
                        ),
                      ),
                      Switch(
                        activeColor: Colors.green,
                        activeTrackColor: Colors.green[200],
                        value: _isOnline,
                        onChanged: (val) {
                          setState(() {
                            _isOnline = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isOnline
                      ? ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _dummyJobs.length,
                          itemBuilder: (context, index) {
                            final job = _dummyJobs[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailScreen(job: job),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            job['title'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.secondaryBlack,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryYellow.withAlpha(80),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              job['budget'],
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(job['address'], style: const TextStyle(color: Colors.grey)),
                                          const Spacer(),
                                          const Icon(Icons.near_me, size: 16, color: Colors.blue),
                                          const SizedBox(width: 4),
                                          Text(job['distance'], style: const TextStyle(color: Colors.blue)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.offline_bolt, size: 80, color: Colors.grey),
                              SizedBox(height: 20),
                              Text("Go Online to receive jobs"),
                            ],
                          ),
                        ),
                ),
              ],
            ),
            
            // Tab 2: Assigned Jobs
            const AssignedJobsScreen(),
          ],
        ),
      ),
    );
  }
}
