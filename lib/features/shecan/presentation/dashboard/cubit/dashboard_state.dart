// lib/features/dashboard/presentation/cubit/dashboard_state.dart

part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String userName;
  final String userAvatarUrl;
  final int userScore;
  final String referralCode;

  const DashboardLoaded({
    required this.userName,
    required this.userAvatarUrl,
    required this.userScore,
    required this.referralCode,
  });

  @override
  List<Object> get props => [userName, userAvatarUrl, userScore, referralCode];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
