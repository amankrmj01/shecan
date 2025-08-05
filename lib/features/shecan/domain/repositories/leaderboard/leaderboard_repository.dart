import '../../entities/leaderboard/leaderboard_entity.dart';

abstract class LeaderboardRepository {
  Future<List<LeaderboardEntity>> getLeaderboardData();

  Future<LeaderboardEntity?> getCurrentUserRank();

  Future<void> updateUserPoints(String userId, int points);
}
