import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../jobs/services/job_service.dart';

class JobDetailScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  JobDetailScreen({super.key, required this.job});

  final _bidController = TextEditingController();
  final JobService _jobService = JobService();

  void _placeBid(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Place Your Bid"),
          content: TextField(
            controller: _bidController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Bid Amount (Rs.)",
              prefixText: "Rs. ",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryYellow),
              onPressed: () async {
                final amountStr = _bidController.text;
                if (amountStr.isEmpty) return;

                final amount = double.tryParse(amountStr);
                if (amount == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                  return;
                }

                try {
                  Navigator.pop(context); // Close dialog
                  // Show loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Placing bid...')),
                  );

                  await _jobService.placeBid(job['_id'], amount);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bid placed successfully!')),
                    );
                    Navigator.pop(context); // Close Detail Screen
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text("Submit Bid", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: AppColors.primaryYellow,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title & Budget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job['title'],
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Text(
                  "Rs. ${job['budget']}",
                  style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Location
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 5),
                Expanded(child: Text(job['location'] ?? "Unknown Location", style: const TextStyle(fontSize: 16, color: Colors.grey))),
              ],
            ),
             const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.category, color: Colors.grey),
                const SizedBox(width: 5),
                Text(job['category'], style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
            const Divider(height: 30),

            // Description
            Text(
              "Description",
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              job['description'] ?? "No description provided.",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[300] : Colors.black87,
              ),
            ),
            
            const Spacer(),

            // Bid Button
            SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryBlack,
                  foregroundColor: AppColors.primaryYellow,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _placeBid(context),
                child: const Text('PLACE BID', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
