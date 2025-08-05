import '../../../domain/entities/leaderboard/leaderboard_entity.dart';
import '../../../domain/repositories/leaderboard/leaderboard_repository.dart';
import '../../datasources/leaderboard/leaderboard_datasource.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardDataSource dataSource;

  LeaderboardRepositoryImpl({required this.dataSource});

  @override
  Future<List<LeaderboardEntity>> getLeaderboardData() async {
    try {
      final models = await dataSource.getLeaderboardData();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch leaderboard data: $e');
    }
  }

  @override
  Future<LeaderboardEntity?> getCurrentUserRank() async {
    try {
      // Since we removed isCurrentUser, we'll need to implement different logic
      // For now, returning null as this method will need custom implementation
      return null;
    } catch (e) {
      throw Exception('Failed to get current user rank: $e');
    }
  }

  @override
  Future<void> updateUserPoints(String userId, int points) async {
    try {
      throw UnimplementedError('Update user points not implemented yet');
    } catch (e) {
      throw Exception('Failed to update user points: $e');
    }
  }
}
