import 'package:get_it/get_it.dart';

import 'package:tw_shows/functions/episodes/data/datasources/network_episodes_data_source.dart';
import 'package:tw_shows/functions/episodes/data/repositories/episodes_repository_impl.dart';
import 'package:tw_shows/functions/episodes/domain/repositories/episodes_repository.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/load_episode_usecase.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/load_show_episodes_usecase.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/create_episode_usecase.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episodes_bloc/episodes_bloc.dart';
import 'package:tw_shows/functions/episodes/view/blocs/single_episode_bloc/single_episode_bloc.dart';

void initiDependenciesEpisodes() {
  final _get = GetIt.instance;

//!datasources

  _get.registerLazySingleton<NetworkEpisodesDataSource>(
      () => NetworkEpisodesDataSourceImpl(_get()));

//!repositories
  _get.registerLazySingleton<EpisodesRepository>(
      () => EpisodesRepositoryImpl(_get(), _get()));

//!usecases
  _get.registerLazySingleton<LoadEpisodeUsecase>(
      () => LoadEpisodeUsecase(_get()));

  _get.registerLazySingleton<LoadShowEpisodesUsecase>(
      () => LoadShowEpisodesUsecase(_get()));

  _get.registerLazySingleton<CreateEpisodeUsecase>(
      () => CreateEpisodeUsecase(_get()));

//!blocs
  _get.registerFactory(() => EpisodesBloc(_get()));
  _get.registerFactory(() => SingleEpisodeBloc(_get()));
}
