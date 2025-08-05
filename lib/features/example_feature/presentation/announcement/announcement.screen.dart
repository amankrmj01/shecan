import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Announcements',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAnnouncementCard(
            title: 'Mid-Internship Review',
            date: 'August 15, 2024',
            content:
                'The mid-internship performance review is scheduled for next week. Please ensure all your data is up to date. More details will be shared via email.',
            icon: Icons.rate_review_rounded,
          ),
          const SizedBox(height: 16),
          _buildAnnouncementCard(
            title: 'New Reward Unlocked!',
            date: 'August 10, 2024',
            content:
                'A new reward tier, "Streak Master," has been added. Maintain a 7-day donation streak to unlock it. Check the rewards section for more details.',
            icon: Icons.new_releases_rounded,
          ),
          const SizedBox(height: 16),
          _buildAnnouncementCard(
            title: 'Weekly Town Hall Meeting',
            date: 'August 8, 2024',
            content:
                'Join us for the weekly town hall this Friday at 4 PM. We will be discussing our progress and goals for the upcoming week.',
            icon: Icons.group_work_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String date,
    required String content,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const Divider(height: 24),
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
