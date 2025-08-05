import '../../entities/user/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUserData();

  Future<UserEntity?> getCurrentUserRank();

  Future<void> updateUserPoints(String userId, int points);
}
