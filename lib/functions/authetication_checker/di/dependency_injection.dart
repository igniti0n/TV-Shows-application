import 'package:get_it/get_it.dart';
import 'package:tw_shows/functions/authetication_checker/domain/usecases/load_rememberd_user_usecase.dart';
import '../view/auth_form_bloc/auth_form_bloc.dart';

void initiDependenciesAuthenticationChecker() {
  final _get = GetIt.instance;

  _get.registerLazySingleton<LoadRememberdUserUsecase>(
      () => LoadRememberdUserUsecase(_get()));

//!blocs
  _get.registerFactory(() => AuthFormBloc(_get()));
}
