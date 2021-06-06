import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../domain/models/user.dart';
import '../../domain/usecases/save_rememberd_user_usecase.dart';
import '../../domain/usecases/sign_in_user_usecase.dart';
import '../../domain/usecases/sign_out_user_usecase.dart';

import '../../../../core/constants/error_messages.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final SignInUserUsecase _signInUserUsecase;
  final SignOutUserUsecase _signOutUsecase;
  final SaveRememberdUserUsecase _saveRememberdUserUsecase;
  AuthBloc(
    this._signInUserUsecase,
    this._signOutUsecase,
    this._saveRememberdUserUsecase,
  ) : super(AuthBlocInitial());

  @override
  Stream<AuthBlocState> mapEventToState(
    AuthBlocEvent event,
  ) async* {
    yield AuthLoading();
    if (event is LogIn) {
      final either = await _signInUserUsecase(
          SignInParams(User(event.email, event.password)));
      yield await _yieldState(
          either, User(event.email, event.password), event.shouldRemember);
    } else if (event is SignOut) {
      final either = await _signOutUsecase(NoParams());
      yield either.fold(
        (l) => AuthFailed(ERROR_NO_CONNECTION),
        (r) => AuthBlocInitial(),
      );
    }
  }

  Future<AuthBlocState> _yieldState(
      Either<Failure, void> either, User user, bool shouldRemember) async {
    return either.fold(
      (Failure failure) {
        return AuthFailed(failure.message);
      },
      (r) async {
        await _saveRememberdUserUsecase(SignInParams(
          shouldRemember ? user : User('', ''),
        ));
        return AuthSuccesfull();
      },
    );
  }
}
