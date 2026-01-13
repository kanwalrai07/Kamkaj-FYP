import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../jobs/services/job_service.dart';
import '../../jobs/services/job_service.dart';

class PostJobScreen extends StatefulWidget {
  final Map<String, dynamic>? job; 
  const PostJobScreen({super.key, this.job});

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

  final JobService _jobService = JobService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _titleController.text = widget.job!['title'];
      _descController.text = widget.job!['description'] ?? '';
      _budgetController.text = widget.job!['budget'].toString();
      _addressController.text = widget.job!['location'];
      _selectedCategory = widget.job!['category'];
      
      if (!_categories.contains(_selectedCategory) && _selectedCategory != null) {
          _categories.add(_selectedCategory!);
      }
    }
  }

  Future<void> _postJob() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final jobData = {
          'title': _titleController.text,
          'description': _descController.text,
          'location': _addressController.text,
          'category': _selectedCategory!,
          'budget': double.parse(_budgetController.text),
        };

        if (widget.job != null) {
           await _jobService.updateJob(widget.job!['_id'], jobData);
           if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Job Updated Successfully!')),
            );
            Navigator.pop(context, true); 
          }
        } else {
          await _jobService.createJob(
            title: _titleController.text,
            description: _descController.text,
            location: _addressController.text,
            category: _selectedCategory!,
            budget: double.parse(_budgetController.text),
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Job Posted Successfully!')),
            );
            Navigator.pop(context, true); 
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job != null ? "Edit Job" : "Post a Job"),
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
                    child: _isLoading 
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryYellow))
                        : Text(
                      widget.job != null ? "UPDATE JOB" : "POST JOB",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
