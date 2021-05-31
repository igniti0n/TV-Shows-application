import 'package:get_it/get_it.dart';
import 'package:tw_shows/functions/authenticating_user/data/datasources/network_user_data_source.dart';
import 'package:tw_shows/functions/authenticating_user/domain/repositories/user_repository.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/save_rememberd_user_usecase.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/sign_in_user_usecase.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/sign_out_user_usecase.dart';
import '../data/repositories/user_repository_impl.dart';
import '../view/auth_bloc/auth_bloc_bloc.dart';

void initiDependenciesAuthenticatingUser() {
  final _get = GetIt.instance;
//!datasources

  _get.registerLazySingleton<NetworkUserDataSource>(
      () => NetworkUserDataSourceImpl(_get()));
  //!repositories
  _get.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(_get(), _get()));

  //!usecases
  _get.registerLazySingleton<SignInUserUsecase>(
      () => SignInUserUsecase(_get()));

  _get.registerLazySingleton<SaveRememberdUserUsecase>(
      () => SaveRememberdUserUsecase(_get()));

  _get.registerLazySingleton<SignOutUserUsecase>(
      () => SignOutUserUsecase(_get()));

  //!blocs
  _get.registerFactory(() => AuthBloc(_get(), _get(), _get()));
}
