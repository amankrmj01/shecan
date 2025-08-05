import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/user_session_service.dart';
import '../../../data/datasources/user/user_datasource.dart';
import '../../../data/models/user/user_model.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  // Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password validation regex pattern (at least 8 chars, 1 letter, 1 number)
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$',
  );

  // Name validation regex pattern (letters, spaces, hyphens, apostrophes)
  static final RegExp _nameRegex = RegExp(r"^[a-zA-Z\s\-']{2,50}$");

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Early validation before emitting loading state
    final validationError = _validateInputs(
      fullName,
      email,
      password,
      confirmPassword,
    );
    if (validationError != null) {
      emit(SignupFailure(error: validationError));
      return;
    }

    emit(SignupLoading());

    try {
      // Simulate API call with realistic delay
      await Future.delayed(const Duration(milliseconds: 1800));

      // Here you would typically call your registration service
      final success = await _registerUser(fullName, email, password);

      if (success) {
        emit(
          SignupSuccess(
            message: 'Welcome aboard! Account created successfully.',
          ),
        );
      } else {
        emit(
          SignupFailure(
            error: 'This email is already registered. Please try logging in.',
          ),
        );
      }
    } catch (e) {
      emit(
        SignupFailure(
          error:
              'Registration failed. Please check your internet and try again.',
        ),
      );
    }
  }

  // Separate validation method for better code organization
  String? _validateInputs(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  ) {
    // Trim whitespace
    fullName = fullName.trim();
    email = email.trim();
    password = password.trim();
    confirmPassword = confirmPassword.trim();

    // Check for empty fields
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      if (fullName.isEmpty) return 'Please enter your full name';
      if (email.isEmpty) return 'Please enter your email address';
      if (password.isEmpty) return 'Please enter a password';
      if (confirmPassword.isEmpty) return 'Please confirm your password';
    }

    // Validate full name
    if (!_nameRegex.hasMatch(fullName)) {
      if (fullName.length < 2) {
        return 'Full name must be at least 2 characters long';
      }
      if (fullName.length > 50) {
        return 'Full name must be less than 50 characters';
      }
      return 'Please enter a valid full name (letters only)';
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

    // Validate password confirmation
    if (password != confirmPassword) {
      return 'Passwords do not match. Please try again.';
    }

    return null; // No validation errors
  }

  // Registration method that adds user to user database
  Future<bool> _registerUser(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final dataSource = LocalUserDataSource();

      // Check if email already exists in the database
      final emailExists = await dataSource.checkEmailExists(
        email.trim().toLowerCase(),
      );
      if (emailExists) {
        return false; // Email already registered
      }

      // Create new user with score 0
      final newUser = UserModel(
        name: fullName.trim(),
        score: 0, // New users start with 0 score
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );

      // Add the new user to the database
      final success = await dataSource.addNewUser(newUser);

      if (success) {
        // Store the new user in session after successful registration
        UserSessionService().setCurrentUser(newUser);
      }

      return success;
    } catch (e) {
      // Log error in production
      print('Registration error: $e');
      return false;
    }
  }

  // Method to validate individual fields (useful for real-time validation)
  bool isValidFullName(String fullName) {
    return _nameRegex.hasMatch(fullName.trim());
  }

  bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  bool isValidPassword(String password) {
    return _passwordRegex.hasMatch(password.trim());
  }

  bool doPasswordsMatch(String password, String confirmPassword) {
    return password.trim() == confirmPassword.trim();
  }

  // Clear any error states
  void clearError() {
    if (state is SignupFailure) {
      emit(SignupInitial());
    }
  }

  void resetState() {
    emit(SignupInitial());
  }
}
