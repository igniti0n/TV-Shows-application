part of 'auth_bloc_bloc.dart';

abstract class AuthBlocState extends Equatable {
  const AuthBlocState();

  @override
  List<Object> get props => [];
}

class AuthBlocInitial extends AuthBlocState {}

class AuthLoading extends AuthBlocState {}

class AuthSuccesfull extends AuthBlocState {}

class AuthFailed extends AuthBlocState {
  final String message;

  AuthFailed(this.message);
}
