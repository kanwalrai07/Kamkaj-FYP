import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/services/theme_service.dart';
import '../../jobs/services/job_service.dart';
import '../../../services/profile_service.dart';
import '../profile_model.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_form.dart';
import '../../client/screens/post_job_screen.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = true;
  bool _isEditing = false;
  
  // Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  String? _profileImagePath;
  
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
  
  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await _profileService.getProfile();
    
    _nameController.text = profile.name ?? '';
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    _addressController.text = profile.address ?? '';
    _profileImagePath = profile.profileImage;
    
    setState(() => _isLoading = false);
  }
  
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final updatedProfile = UserProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      role: 'client',
      profileImage: _profileImagePath,
    );
    
    await _profileService.saveProfile(updatedProfile);
    
    setState(() {
      _isLoading = false;
      _isEditing = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Updated Successfully')),
      );
    }
  }

  void _logout() async {
    await _profileService.logout();
     if (mounted) {
       Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ThemeService().toggleTheme(),
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _saveProfile : () => setState(() => _isEditing = true),
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryYellow))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ProfileAvatar(
                  imagePath: _profileImagePath,
                  isEditing: _isEditing,
                  onImageSelected: (path) => setState(() => _profileImagePath = path),
                ),
                const SizedBox(height: 20),
                
                Text(
                  _nameController.text.isEmpty ? 'Client Name' : _nameController.text,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text('Client Account', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                
                // TABS
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.primaryYellow 
                            : AppColors.secondaryBlack,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.primaryYellow,
                        tabs: const [
                          Tab(text: "Profile Info"),
                          Tab(text: "My Jobs"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 400, // Fixed height for tab view inside scrollview
                        child: TabBarView(
                          children: [
                            // TAB 1: Profile Form
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  ProfileForm(
                                    formKey: _formKey,
                                    nameController: _nameController,
                                    emailController: _emailController,
                                    phoneController: _phoneController,
                                    addressController: _addressController,
                                    isEditing: _isEditing,
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.logout, color: Colors.red),
                                      label: const Text('Logout', style: TextStyle(color: Colors.red)),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: _logout,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // TAB 2: My Jobs
                            _MyJobsList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _MyJobsList extends StatefulWidget {
  @override
  State<_MyJobsList> createState() => _MyJobsListState();
}

class _MyJobsListState extends State<_MyJobsList> {
  final JobService _jobService = JobService();
  List<dynamic> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final jobs = await _jobService.getMyJobs();
      if (mounted) {
        setState(() {
          _jobs = jobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      print("Error fetching jobs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_jobs.isEmpty) {
      return const Center(child: Text("No jobs posted yet."));
    }

    return ListView.builder(
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(job['title'], style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${job['category']} • Rs. ${job['budget']}",
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[700]),
                ),
                Text(job['status'], style: TextStyle(
                  color: job['status'] == 'OPEN' ? Colors.green : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                )),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // EDIT BUTTON
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                     final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostJobScreen(job: job),
                      ),
                    );
                    if (result == true) {
                      _fetchJobs(); // Refresh list after edit
                    }
                  },
                ),
                // DELETE BUTTON
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(job['_id']),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(String jobId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Job"),
        content: const Text("Are you sure you want to delete this job?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _deleteJob(jobId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteJob(String jobId) async {
    setState(() => _isLoading = true);
    try {
      await _jobService.deleteJob(jobId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job Deleted Successfully')),
        );
      }
      _fetchJobs(); // Refresh list
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
