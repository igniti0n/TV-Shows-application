import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/functions/authetication_checker/domain/usecases/load_rememberd_user_usecase.dart';
import '../../domain/models/auth_credentials.dart';
import 'package:stream_transform/stream_transform.dart';

part 'auth_form_event.dart';
part 'auth_form_state.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  final LoadRememberdUserUsecase _loadRememberdUserUsecase;
  AuthFormBloc(this._loadRememberdUserUsecase)
      : super(AuthFormInitial(AuthCredentials(
          emailCredential: EmailCredential.initial(),
          passwordCredential: PasswordCredential.initial(),
          isObscured: true,
          isRemember: false,
        )));

  @override
  Stream<Transition<AuthFormEvent, AuthFormState>> transformEvents(
      Stream<AuthFormEvent> events,
      TransitionFunction<AuthFormEvent, AuthFormState> transitionFn) {
    final debounce = StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 100)))
        .cast<AuthFormEvent, AuthFormEvent>();
    Stream<AuthFormEvent> _debuonceStream = events.transform(debounce);
    return super.transformEvents(_debuonceStream, transitionFn);
  }

  @override
  Stream<AuthFormState> mapEventToState(
    AuthFormEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield AuthFormChanged(state.authCredentials
          .copyWith(emailCredential: EmailCredential(event.email)));
    } else if (event is PasswordChanged) {
      yield AuthFormChanged(state.authCredentials
          .copyWith(passwordCredential: PasswordCredential(event.password)));
    } else if (event is InitialLoad) {
      yield await _tryLoadRememberdUserCredentials();
    } else if (event is ObscurePasswordChanged) {
      yield AuthFormChanged(
          state.authCredentials.copyWith(isObscured: event.isObscured));
    } else if (event is RememberUserChanged) {
      yield AuthFormChanged(
          state.authCredentials.copyWith(isRemember: event.isRemember));
    }
  }

  Future<AuthFormState> _tryLoadRememberdUserCredentials() async {
    final _res = await _loadRememberdUserUsecase(NoParams());
    return _res.fold(
      (l) => AuthFormInitial(
        AuthCredentials(
          emailCredential: EmailCredential.initial(),
          passwordCredential: PasswordCredential.initial(),
          isObscured: true,
          isRemember: false,
        ),
      ),
      (r) => AuthFormInitial(
        AuthCredentials(
          emailCredential: r.email.isEmpty
              ? EmailCredential.initial()
              : EmailCredential(r.email),
          passwordCredential: r.password.isEmpty
              ? PasswordCredential.initial()
              : PasswordCredential(r.password),
          isObscured: true,
          isRemember: r.email.isEmpty ? false : true,
        ),
      ),
    );
  }
}
