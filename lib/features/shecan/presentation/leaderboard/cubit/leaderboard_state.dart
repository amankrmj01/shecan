part of 'leaderboard_cubit.dart';

abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<UserEntity> leaderboardData;

  LeaderboardLoaded({required this.leaderboardData});
}

class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError({required this.message});
}
