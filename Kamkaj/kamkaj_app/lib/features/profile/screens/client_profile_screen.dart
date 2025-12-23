import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../services/profile_service.dart';
import '../profile_model.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_form.dart';

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
                const SizedBox(height: 30),
                
                ProfileForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  addressController: _addressController,
                  isEditing: _isEditing,
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
}
