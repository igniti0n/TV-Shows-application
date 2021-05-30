import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/functions/authenticating_user/domain/models/user.dart';
import 'package:tw_shows/functions/authenticating_user/domain/repositories/user_repository.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/sign_in_user_usecase.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/sign_out_user_usecase.dart';

import '../../../../core/constants/error_messages.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final SignInUserUsecase _signInUserUsecase;
  final SignOutUserUsecase _signOutUsecase;
  AuthBloc(this._signInUserUsecase, this._signOutUsecase)
      : super(AuthBlocInitial());

  @override
  Stream<AuthBlocState> mapEventToState(
    AuthBlocEvent event,
  ) async* {
    yield AuthLoading();
    if (event is LogIn) {
      final either = await _signInUserUsecase(
          SignInParams(User(event.email, event.password)));
      yield _yieldState(either);
    } else if (event is SignOut) {
      final either = await _signOutUsecase(NoParams());
      yield either.fold(
        (l) => AuthFailed(ERROR_NO_CONNECTION),
        (r) => AuthBlocInitial(),
      );
    }
  }

  AuthBlocState _yieldState(Either<Failure, void> either) {
    return either.fold(
      (Failure failure) {
        return AuthFailed(failure.message);
      },
      (r) => AuthSuccesfull(),
    );
  }
}
