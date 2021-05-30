part of 'auth_form_bloc.dart';

abstract class AuthFormEvent extends Equatable {
  const AuthFormEvent();
}

class InitialLoad extends AuthFormEvent {
  @override
  List<Object> get props => [];
}

class EmailChanged extends AuthFormEvent {
  final String email;

  EmailChanged(this.email);

  @override
  List<Object> get props => [];
}

class PasswordChanged extends AuthFormEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object?> get props => [];
}

class PasswordConfirmChanged extends AuthFormEvent {
  final String password;
  final String confirmPass;

  PasswordConfirmChanged(this.password, this.confirmPass);

  @override
  List<Object?> get props => [];
}
