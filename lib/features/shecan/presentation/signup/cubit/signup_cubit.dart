import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      emit(SignupLoading());

      await Future.delayed(const Duration(seconds: 2));

      if (fullName.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        emit(SignupFailure(error: 'Please fill in all fields'));
        return;
      }

      if (!email.contains('@')) {
        emit(SignupFailure(error: 'Please enter a valid email'));
        return;
      }

      if (password.length < 6) {
        emit(SignupFailure(error: 'Password must be at least 6 characters'));
        return;
      }

      if (password != confirmPassword) {
        emit(SignupFailure(error: 'Passwords do not match'));
        return;
      }

      // Simulate successful signup
      emit(SignupSuccess(message: 'Account Created Successfully!'));
    } catch (e) {
      emit(SignupFailure(error: 'An unexpected error occurred'));
    }
  }

  void resetState() {
    emit(SignupInitial());
  }
}
