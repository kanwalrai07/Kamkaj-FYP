import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/services/theme_service.dart';
import '../../auth/services/auth_service.dart';
import '../../jobs/services/job_service.dart';
import 'job_detail_screen.dart';
import 'assigned_jobs_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  final AuthService _authService = AuthService();
  final JobService _jobService = JobService();
  bool _isOnline = false;
  List<dynamic> _jobs = [];
  bool _isLoading = false;

  Future<void> _fetchOpenJobs() async {
    setState(() => _isLoading = true);
    try {
      final jobs = await _jobService.getOpenJobs();
      if (mounted) {
        setState(() {
          _jobs = jobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching open jobs: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    // In a real app, you might want check online status first
  }

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/role-selection');
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => ThemeService().toggleTheme(),
            ),
            IconButton(
              icon: const Icon(Icons.person), 
              onPressed: () {
                Navigator.pushNamed(context, '/worker-profile');
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            indicatorColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            tabs: const [
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
                            if (_isOnline) {
                              _fetchOpenJobs();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: _isLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : _jobs.isEmpty 
                              ? const Center(child: Text("No jobs available"))
                              : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _jobs.length,
                          itemBuilder: (context, index) {
                            final job = _jobs[index];
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
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).brightness == Brightness.dark 
                                                  ? Colors.white 
                                                  : AppColors.secondaryBlack,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryYellow.withAlpha(80),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "Rs. ${job['budget']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).brightness == Brightness.dark 
                                                    ? Colors.white 
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          const SizedBox(width: 4),
                                          Text(job['location'] ?? 'N/A', style: const TextStyle(color: Colors.grey)),
                                          const Spacer(),
                                          const Icon(Icons.near_me, size: 16, color: Colors.blue),
                                          const SizedBox(width: 4),
                                          const Text("2 km", style: TextStyle(color: Colors.blue)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
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
