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
  List<Object> get props => [email];
}

class PasswordChanged extends AuthFormEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ObscurePasswordChanged extends AuthFormEvent {
  final bool isObscured;

  ObscurePasswordChanged(this.isObscured);

  @override
  List<Object> get props => [isObscured];
}

class RememberUserChanged extends AuthFormEvent {
  final bool isRemember;

  RememberUserChanged(this.isRemember);

  @override
  List<Object> get props => [isRemember];
}
