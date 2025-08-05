import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/user_session_service.dart';
import '../../../data/datasources/user/user_datasource.dart';
import '../../../data/models/user/user_model.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final UserDataSource _userDataSource;

  SignupCubit({required UserDataSource userDataSource})
    : _userDataSource = userDataSource,
      super(SignupInitial());

  // Regex patterns remain for internal validation
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$',
  );
  static final RegExp _nameRegex = RegExp(r"^[a-zA-Z\s\-']{2,50}$");

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
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
      await Future.delayed(const Duration(milliseconds: 1800));

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

  String? _validateInputs(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  ) {
    if (fullName.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty) {
      return 'All fields are required. Please fill out the form completely.';
    }
    if (!_nameRegex.hasMatch(fullName.trim())) {
      return 'Please enter a valid full name (letters only).';
    }
    if (!_emailRegex.hasMatch(email.trim())) {
      return 'Please enter a valid email address.';
    }
    if (password.length < 8 || !_passwordRegex.hasMatch(password)) {
      return 'Password must be at least 8 characters with one letter and one number.';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match. Please try again.';
    }
    return null;
  }

  Future<bool> _registerUser(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final emailExists = await _userDataSource.checkEmailExists(
        email.trim().toLowerCase(),
      );
      if (emailExists) {
        return false;
      }

      final newUser = UserModel(
        name: fullName.trim(),
        score: 0,
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );

      final success = await _userDataSource.addNewUser(newUser);

      if (success) {
        UserSessionService().setCurrentUser(newUser);
      }
      return success;
    } catch (e) {
      // ignore: avoid_print
      print('Registration error: $e');
      return false;
    }
  }

  void resetState() {
    emit(SignupInitial());
  }
}
