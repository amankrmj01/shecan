import '../../entities/user/user_entity.dart';
import '../../repositories/user/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase({required this.repository});

  Future<List<UserEntity>> call() async {
    try {
      final leaderboard = await repository.getUserData();

      leaderboard.sort((a, b) => b.points.compareTo(a.points));

      for (int i = 0; i < leaderboard.length; i++) {}

      return leaderboard;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }
}
