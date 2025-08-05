part of 'user_profile_cubit.dart';

abstract class UserProfileState {
  const UserProfileState();
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserModel user;
  final bool notificationsEnabled;
  final AppThemeMode themeMode;

  const UserProfileLoaded({
    required this.user,
    required this.notificationsEnabled,
    required this.themeMode,
  });

  UserProfileLoaded copyWith({
    UserModel? user,
    bool? notificationsEnabled,
    AppThemeMode? themeMode,
  }) {
    return UserProfileLoaded(
      user: user ?? this.user,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);
}

class UserProfileLoggedOut extends UserProfileState {}
