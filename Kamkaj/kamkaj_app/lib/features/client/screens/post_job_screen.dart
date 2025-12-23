import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _budgetController = TextEditingController();
  final _addressController = TextEditingController();
  
  String? _selectedCategory;
  final List<String> _categories = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Painter',
    'Cleaner',
    'Gardener',
  ];

  void _postJob() {
    if (_formKey.currentState!.validate()) {
      // TODO: Connect to Backend API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Posting Job... (Mock)')),
      );
      
      print("Job Details:");
      print("Category: $_selectedCategory");
      print("Title: ${_titleController.text}");
      print("Desc: ${_descController.text}");
      print("Budget: ${_budgetController.text}");
      print("Address: ${_addressController.text}");

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Job Posted Successfully!')),
          );
          Navigator.pop(context); // Go back to Home
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post a Job"),
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Category Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  },
                  validator: (val) => val == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 20),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Job Title (e.g., Fix Fan)",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 20),

                // Description
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 20),

                // Budget
                TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Budget (PKR)",
                    prefixText: "Rs. ",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter a budget' : null,
                ),
                const SizedBox(height: 20),

                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: "Address",
                    suffixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter an address' : null,
                ),
                const SizedBox(height: 30),

                // Post Button
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryBlack,
                      foregroundColor: AppColors.primaryYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _postJob,
                    child: const Text(
                      "POST JOB",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
