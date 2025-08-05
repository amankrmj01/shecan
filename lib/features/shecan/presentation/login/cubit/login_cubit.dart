import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/user_session_service.dart';
import '../../../data/datasources/user/user_datasource.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  // Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password validation regex pattern (at least 8 chars, 1 letter, 1 number)
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$',
  );

  Future<void> login({required String email, required String password}) async {
    // Early validation before emitting loading state
    final validationError = _validateInputs(email, password);
    if (validationError != null) {
      emit(LoginFailure(error: validationError));
      return;
    }

    emit(LoginLoading());

    try {
      // Simulate API call with realistic delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Here you would typically call your authentication service
      final success = await _authenticateUser(email, password);

      if (success) {
        emit(LoginSuccess(message: 'Welcome back! Login successful.'));
      } else {
        emit(
          LoginFailure(error: 'Invalid email or password. Please try again.'),
        );
      }
    } catch (e) {
      emit(
        LoginFailure(
          error: 'Connection failed. Please check your internet and try again.',
        ),
      );
    }
  }

  // Separate validation method for better code organization
  String? _validateInputs(String email, String password) {
    // Trim whitespace
    email = email.trim();
    password = password.trim();

    // Check for empty fields
    if (email.isEmpty && password.isEmpty) {
      return 'Please enter your email and password';
    }
    if (email.isEmpty) {
      return 'Please enter your email address';
    }
    if (password.isEmpty) {
      return 'Please enter your password';
    }

    // Validate email format
    if (!_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    // Validate password strength
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!_passwordRegex.hasMatch(password)) {
      return 'Password must contain at least one letter and one number';
    }

    return null; // No validation errors
  }

  // Authentication method that checks against user database
  Future<bool> _authenticateUser(String email, String password) async {
    try {
      // Get user data which contains all user credentials
      final dataSource = LocalUserDataSource();
      final leaderboardModels = await dataSource.getUserData();

      // Trim inputs for comparison
      final trimmedEmail = email.trim().toLowerCase();
      final trimmedPassword = password.trim();

      // Search for user with matching email and password
      for (final user in leaderboardModels) {
        if (user.email.toLowerCase() == trimmedEmail &&
            user.password == trimmedPassword) {
          // User found with correct credentials - store in session
          UserSessionService().setCurrentUser(user);
          return true;
        }
      }

      // No matching user found
      return false;
    } catch (e) {
      // Log error in production
      print('Authentication error: $e');
      return false;
    }
  }

  // Method to validate individual fields (useful for real-time validation)
  bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  bool isValidPassword(String password) {
    return _passwordRegex.hasMatch(password.trim());
  }

  // Clear any error states
  void clearError() {
    if (state is LoginFailure) {
      emit(LoginInitial());
    }
  }

  void resetState() {
    emit(LoginInitial());
  }
}
