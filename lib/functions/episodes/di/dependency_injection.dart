import 'package:get_it/get_it.dart';

import '../data/datasources/network_episodes_data_source.dart';
import '../data/repositories/episodes_repository_impl.dart';
import '../domain/repositories/episodes_repository.dart';
import '../domain/usecases/load_episode_usecase.dart';
import '../domain/usecases/load_show_episodes_usecase.dart';
import '../domain/usecases/create_episode_usecase.dart';
import '../domain/usecases/pick_image_usecase.dart';
import '../view/blocs/episode_creation_bloc.dart/episode_creation_bloc.dart';
import '../view/blocs/episode_form_bloc/episode_form_bloc.dart';
import '../view/blocs/episode_image/episode_image_bloc.dart';
import '../view/blocs/episodes_bloc/episodes_bloc.dart';
import '../view/blocs/single_episode_bloc/single_episode_bloc.dart';

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

  _get.registerLazySingleton<PickImageUsecase>(() => PickImageUsecase(_get()));

//!blocs
  _get.registerFactory(() => EpisodesBloc(_get()));
  _get.registerFactory(() => SingleEpisodeBloc(_get()));
  _get.registerFactory(() => EpisodeFormBloc());
  _get.registerFactory(() => EpisodeCreationBloc(_get()));
  _get.registerFactory(() => EpisodeImageBloc(_get()));
}
