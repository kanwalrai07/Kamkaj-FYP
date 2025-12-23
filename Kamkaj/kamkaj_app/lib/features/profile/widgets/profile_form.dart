import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final bool isEditing;
  final List<Widget> additionalFields; // For role-specific fields (e.g. Worker Skills)
  final GlobalKey<FormState> formKey;

  const ProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.formKey,
    this.isEditing = false,
    this.additionalFields = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildTextField(
            label: 'Full Name',
            controller: nameController,
            icon: Icons.person_outline,
            validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 15),
          
          _buildTextField(
            label: 'Email Address',
            controller: emailController,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
             validator: (val) {
              if (val == null || val.isEmpty) return 'Please enter email';
              if (!val.contains('@')) return 'Please enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 15),
          
          _buildTextField(
            label: 'Phone Number',
            controller: phoneController,
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            validator: (val) => val == null || val.isEmpty ? 'Please enter phone number' : null,
          ),
          const SizedBox(height: 15),
          
          _buildTextField(
            label: 'Home Address',
            controller: addressController,
            icon: Icons.location_on_outlined,
            validator: (val) => val == null || val.isEmpty ? 'Please enter address' : null,
          ),
          
          // Add extra fields (Skills etc.)
          ...additionalFields,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: isEditing,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: isEditing ? Colors.white : Colors.grey[100],
      ),
    );
  }
}
