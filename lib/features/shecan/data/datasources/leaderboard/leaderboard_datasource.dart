import '../../models/leaderboard/leaderboard_model.dart';

abstract class LeaderboardDataSource {
  Future<List<LeaderboardModel>> getLeaderboardData();
}

class LocalLeaderboardDataSource implements LeaderboardDataSource {
  static const List<Map<String, dynamic>> _mockData = [
    {'name': 'Jessica Lee', 'score': 15200, 'rank': 1, 'isCurrentUser': false},
    {'name': 'Michael Chen', 'score': 12500, 'rank': 2, 'isCurrentUser': false},
    {
      'name': 'David Rodriguez',
      'score': 9800,
      'rank': 3,
      'isCurrentUser': false,
    },
    {'name': 'Alex (You)', 'score': 5000, 'rank': 4, 'isCurrentUser': true},
    {'name': 'Emily White', 'score': 4500, 'rank': 5, 'isCurrentUser': false},
    {'name': 'Sarah Johnson', 'score': 4200, 'rank': 6, 'isCurrentUser': false},
    {'name': 'Tom Wilson', 'score': 3800, 'rank': 7, 'isCurrentUser': false},
    {'name': 'Maria Garcia', 'score': 3500, 'rank': 8, 'isCurrentUser': false},
  ];

  @override
  Future<List<LeaderboardModel>> getLeaderboardData() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return _mockData.map((data) => LeaderboardModel.fromJson(data)).toList();
  }
}
