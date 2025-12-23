import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class AssignedJobsScreen extends StatelessWidget {
  const AssignedJobsScreen({super.key});

  final List<Map<String, dynamic>> _assignedJobs = const [
    {
      'title': 'AC Service',
      'address': 'DHA Phase 6, Lahore',
      'budget': 'Rs. 2500',
      'category': 'Electrician',
      'status': 'In Progress'
    },
    {
      'title': 'Leaking Pipe Fix',
      'address': 'Bahria Town, Lahore',
      'budget': 'Rs. 1500',
      'category': 'Plumber',
      'status': 'Pending'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assigned Jobs'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _assignedJobs.length,
        itemBuilder: (context, index) {
          final job = _assignedJobs[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryYellow.withAlpha(50),
                child: Icon(Icons.work, color: AppColors.secondaryBlack),
              ),
              title: Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job['address']),
                  Text(job['status'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
              trailing: Text(job['budget'], style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                // Navigate to tracking or details
              },
            ),
          );
        },
      ),
    );
  }
}
