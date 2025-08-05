import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/theme_service.dart';
import '../../../../../core/services/user_session_service.dart';
import '../../../data/models/user/user_model.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserSessionService _userSessionService;
  final ThemeService _themeService;

  UserProfileCubit({
    required UserSessionService userSessionService,
    required ThemeService themeService,
  }) : _userSessionService = userSessionService,
       _themeService = themeService,
       super(UserProfileInitial());

  void loadUserProfile() {
    emit(UserProfileLoading());
    try {
      final currentUser = _userSessionService.currentUser!;
      emit(
        UserProfileLoaded(
          user: currentUser,
          notificationsEnabled: true,
          // Default value, could be loaded from preferences
          themeMode: _themeService.themeMode,
        ),
      );
    } catch (e) {
      emit(UserProfileError('Failed to load user profile: $e'));
    }
  }

  void toggleNotifications() {
    if (state is UserProfileLoaded) {
      final currentState = state as UserProfileLoaded;
      emit(
        currentState.copyWith(
          notificationsEnabled: !currentState.notificationsEnabled,
        ),
      );
    }
  }

  void updateTheme(AppThemeMode themeMode) {
    try {
      _themeService.setThemeMode(themeMode);
      if (state is UserProfileLoaded) {
        final currentState = state as UserProfileLoaded;
        emit(currentState.copyWith(themeMode: themeMode));
      }
    } catch (e) {
      emit(UserProfileError('Failed to update theme: $e'));
    }
  }

  void logout() async {
    try {
      _userSessionService.clearCurrentUser();
      emit(UserProfileLoggedOut());
    } catch (e) {
      emit(UserProfileError('Failed to logout: $e'));
    }
  }

  // Getters for easy access
  String get currentUserName => _userSessionService.currentUserName;

  String get currentUserEmail => _userSessionService.currentUserEmail;

  int get currentUserScore => _userSessionService.currentUserScore;

  String get themeModeString => _themeService.themeModeString;
}
