part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckedRequested extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String userId;

  const LoggedIn(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoggedOut extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String name;
  final String password;
  final String email;

  const SignUpRequested(this.name, this.password, this.email);

  @override
  List<Object> get props => [name, email, password];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
