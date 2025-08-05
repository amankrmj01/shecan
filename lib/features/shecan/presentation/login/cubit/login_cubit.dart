import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    try {
      emit(LoginLoading());

      await Future.delayed(const Duration(seconds: 2));

      if (email.isEmpty || password.isEmpty) {
        emit(LoginFailure(error: 'Please fill in all fields'));
        return;
      }

      if (!email.contains('@')) {
        emit(LoginFailure(error: 'Please enter a valid email'));
        return;
      }

      if (password.length < 6) {
        emit(LoginFailure(error: 'Password must be at least 6 characters'));
        return;
      }

      emit(LoginSuccess(message: 'Login Successful!'));
    } catch (e) {
      emit(LoginFailure(error: 'An unexpected error occurred'));
    }
  }

  void resetState() {
    emit(LoginInitial());
  }
}
