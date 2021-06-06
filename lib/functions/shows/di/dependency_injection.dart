import 'package:get_it/get_it.dart';

import '../data/datasources/network_data_source.dart';
import '../data/repositories/shows_repository_impl.dart';
import '../domain/repositories/shows_repository.dart';
import '../domain/usecases/load_show_usecase_impl.dart';
import '../domain/usecases/load_shows_usecase_impl.dart';
import '../view/blocs/shows_bloc/shows_bloc.dart';
import '../view/blocs/single_show_bloc/single_show_bloc.dart';

void initiDependenciesShows() {
  final _get = GetIt.instance;

//!datasources

  _get.registerLazySingleton<NetworkShowsDataSource>(
      () => NetworkShowsDataSourceImpl(_get()));

//!repositories
  _get.registerLazySingleton<ShowsRepository>(
      () => ShowsRepositoryImpl(_get(), _get()));

//!usecases
  _get.registerLazySingleton<LoadShowUsecase>(() => LoadShowUsecase(_get()));

  _get.registerLazySingleton<LoadShowsUsecase>(() => LoadShowsUsecase(_get()));

//!blocs
  _get.registerFactory(() => ShowsBloc(_get()));
  _get.registerFactory(() => SingleShowBloc(_get()));
}
