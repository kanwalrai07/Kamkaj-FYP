import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class JobDetailScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailScreen({super.key, required this.job});

  void _placeBid(BuildContext context) {
    // Mock Bid Logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bid placed successfully! Client will notify you.')),
    );
    Navigator.pop(context);
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
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  job['budget'],
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
                Expanded(child: Text(job['address'], style: const TextStyle(fontSize: 16, color: Colors.grey))),
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
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Needs urgent fixing.",
              style: const TextStyle(fontSize: 16),
            ),
            
            const Spacer(),

            // TODO: Maps Integration for Route
            Container(
              height: 150,
              color: Colors.grey[200],
              child: const Center(child: Text("Map Route Preview (TODO)")),
            ),
            const SizedBox(height: 20),

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
