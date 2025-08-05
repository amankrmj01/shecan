import '../../entities/leaderboard/leaderboard_entity.dart';
import '../../repositories/leaderboard/leaderboard_repository.dart';

class GetLeaderboardUseCase {
  final LeaderboardRepository repository;

  GetLeaderboardUseCase({required this.repository});

  Future<List<LeaderboardEntity>> call() async {
    try {
      final leaderboard = await repository.getLeaderboardData();

      leaderboard.sort((a, b) => b.points.compareTo(a.points));

      for (int i = 0; i < leaderboard.length; i++) {}

      return leaderboard;
    } catch (e) {
      throw Exception('Failed to get leaderboard: $e');
    }
  }
}
