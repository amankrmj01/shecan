part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String message;

  const SignupSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class SignupFailure extends SignupState {
  final String error;

  const SignupFailure({required this.error});

  @override
  List<Object> get props => [error];
}
