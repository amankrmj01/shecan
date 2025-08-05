import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  final List<Map<String, dynamic>> leaderboardData = const [
    {'name': 'Jessica Lee', 'score': 15200, 'rank': 1},
    {'name': 'Michael Chen', 'score': 12500, 'rank': 2},
    {'name': 'David Rodriguez', 'score': 9800, 'rank': 3},
    {'name': 'Alex (You)', 'score': 5000, 'rank': 4},
    {'name': 'Emily White', 'score': 4500, 'rank': 5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final entry = leaderboardData[index];
          final isCurrentUser = entry['name'] == 'Alex (You)';
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            color: isCurrentUser ? Colors.deepPurple[50] : Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getRankColor(entry['rank']),
                child: Text(
                  '${entry['rank']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                entry['name'],
                style: TextStyle(
                  fontWeight: isCurrentUser
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              trailing: Text(
                '₹${entry['score']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Colors.deepPurple;
    }
  }
}
