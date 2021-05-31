part of 'auth_bloc_bloc.dart';

abstract class AuthBlocEvent extends Equatable {
  const AuthBlocEvent();

  @override
  List<Object> get props => [];
}

class LogIn extends AuthBlocEvent {
  final String email;
  final String password;
  final bool shouldRemember;

  LogIn(
    this.email,
    this.password,
    this.shouldRemember,
  );
}

class SignUp extends AuthBlocEvent {
  final String email;
  final String password;

  SignUp(this.email, this.password);
}

class SignOut extends AuthBlocEvent {}
