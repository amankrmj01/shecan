// lib/features/dashboard/presentation/cubit/dashboard_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/services/user_session_service.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final UserSessionService _userSessionService;

  DashboardCubit()
    : _userSessionService = sl<UserSessionService>(),
      super(DashboardInitial());

  Future<void> loadDashboardData() async {
    try {
      emit(DashboardLoading());

      // Simulate a network call or data fetching
      await Future.delayed(const Duration(milliseconds: 500));

      final userName = _userSessionService.currentUserName;
      final userScore = _userSessionService.currentUserScore;

      if (userName.isEmpty) {
        emit(const DashboardError('User not found. Please log in again.'));
        return;
      }

      final referralCode = '${userName.toLowerCase().split(' ').join('_')}2025';
      final userAvatarUrl =
          'https://api.dicebear.com/9.x/initials/png?seed=${Uri.encodeComponent(userName)}&size=64';

      emit(
        DashboardLoaded(
          userName: userName,
          userScore: userScore,
          referralCode: referralCode,
          userAvatarUrl: userAvatarUrl,
        ),
      );
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: ${e.toString()}'));
    }
  }
}
