part of 'signup_cubit.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String message;

  SignupSuccess({required this.message});
}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure({required this.error});
}
