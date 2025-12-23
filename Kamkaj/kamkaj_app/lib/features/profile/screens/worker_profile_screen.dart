import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../services/profile_service.dart';
import '../profile_model.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_form.dart';

class WorkerProfileScreen extends StatefulWidget {
  const WorkerProfileScreen({super.key});

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = true;
  bool _isEditing = false;
  
  // Basic Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Worker Specific Controllers
  // In a real app, Skill might be a dropdown. Using text for simplicity.
  final _skillController = TextEditingController(); 
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();

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
    
    _skillController.text = profile.skillCategory ?? '';
    _experienceController.text = profile.experience ?? '';
    _bioController.text = profile.bio ?? '';
    
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
      role: 'worker',
      profileImage: _profileImagePath,
      skillCategory: _skillController.text,
      experience: _experienceController.text,
      bio: _bioController.text,
    );
    
    await _profileService.saveProfile(updatedProfile);
    
    setState(() {
      _isLoading = false;
      _isEditing = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Worker Profile Updated!')),
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
        title: const Text('Worker Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
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
                  _nameController.text.isEmpty ? 'Worker Name' : _nameController.text,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  _skillController.text.isEmpty ? 'Skill Not Set' : _skillController.text,
                  style: const TextStyle(color: AppColors.primaryYellow, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 30),
                
                ProfileForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  addressController: _addressController,
                  isEditing: _isEditing,
                  additionalFields: [
                     const SizedBox(height: 15),
                     const Divider(),
                     const SizedBox(height: 15),
                     const Align(
                       alignment: Alignment.centerLeft,
                       child: Text('Professional Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                     ),
                     const SizedBox(height: 15),
                     
                     // Skill Field
                     TextFormField(
                      controller: _skillController,
                      enabled: _isEditing,
                      decoration: _buildInputDecoration('Skill Category (e.g. Plumber)', Icons.work_outline),
                    ),
                    const SizedBox(height: 15),
                    
                    // Experience Field
                    TextFormField(
                      controller: _experienceController,
                      enabled: _isEditing,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration('Experience (Years)', Icons.history),
                    ),
                    const SizedBox(height: 15),
                    
                    // Bio Field
                    TextFormField(
                      controller: _bioController,
                      enabled: _isEditing,
                      maxLines: 3,
                      decoration: _buildInputDecoration('Short Bio', Icons.description_outlined),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
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
    );
  }
  
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      filled: true,
      fillColor: _isEditing ? Colors.white : Colors.grey[100],
    );
  }
}
