import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/usecases/user/get_user_usecase.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final GetUserUseCase getLeaderboardUseCase;

  LeaderboardCubit({required this.getLeaderboardUseCase})
    : super(LeaderboardInitial());

  Future<void> loadLeaderboard() async {
    try {
      emit(LeaderboardLoading());
      final leaderboardData = await getLeaderboardUseCase();
      emit(LeaderboardLoaded(leaderboardData: leaderboardData));
    } catch (e) {
      emit(LeaderboardError(message: e.toString()));
    }
  }

  void refreshLeaderboard() {
    loadLeaderboard();
  }

  void resetState() {
    emit(LeaderboardInitial());
  }
}
