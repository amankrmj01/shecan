import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/leaderboard/leaderboard_entity.dart';
import '../../../domain/usecases/leaderboard/get_leaderboard_usecase.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final GetLeaderboardUseCase getLeaderboardUseCase;

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
