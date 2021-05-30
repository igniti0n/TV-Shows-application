part of 'auth_form_bloc.dart';

abstract class AuthFormState extends Equatable {
  final AuthCredentials authCredentials;
  const AuthFormState(this.authCredentials);
  @override
  List<Object?> get props => [authCredentials];
}

class AuthFormInitial extends AuthFormState {
  AuthFormInitial(AuthCredentials authCredentials) : super(authCredentials);
}

class AuthFormChanged extends AuthFormState {
  AuthFormChanged(AuthCredentials authCredentials) : super(authCredentials);
}
