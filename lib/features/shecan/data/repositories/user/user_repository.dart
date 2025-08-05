import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/repositories/user/user_repository.dart';
import '../../datasources/user/user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<List<UserEntity>> getUserData() async {
    try {
      final models = await dataSource.getUserData();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  @override
  Future<UserEntity?> getCurrentUserRank() async {
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
