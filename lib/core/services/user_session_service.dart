import '../../features/shecan/data/models/leaderboard/leaderboard_model.dart';

class UserSessionService {
  static final UserSessionService _instance = UserSessionService._internal();

  factory UserSessionService() => _instance;

  UserSessionService._internal();

  LeaderboardModel? _currentUser;

  // Get current logged-in user
  LeaderboardModel? get currentUser => _currentUser;

  // Set current user after login/signup
  void setCurrentUser(LeaderboardModel user) {
    _currentUser = user;
  }

  // Clear user session (logout)
  void clearCurrentUser() {
    _currentUser = null;
  }

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Get current user's name
  String get currentUserName => _currentUser?.name ?? 'Guest';

  // Get current user's email
  String get currentUserEmail => _currentUser?.email ?? '';

  // Get current user's score
  int get currentUserScore => _currentUser?.score ?? 0;

  // Check if a user is the current user by email
  bool isCurrentUser(String email) {
    return _currentUser?.email.toLowerCase() == email.toLowerCase();
  }

  // Update current user's score
  void updateCurrentUserScore(int newScore) {
    if (_currentUser != null) {
      _currentUser = LeaderboardModel(
        name: _currentUser!.name,
        score: newScore,
        email: _currentUser!.email,
        password: _currentUser!.password,
      );
    }
  }
}
