import 'package:get_it/get_it.dart';
import '../../authetication_checker/domain/usecases/load_rememberd_user_usecase.dart';
import '../data/datasource/network_comments_data_source.dart';
import '../data/repositories/comments_repository_impl.dart';
import '../domain/repositories/comments_repository.dart';
import '../domain/usecases/create_new_comment_usecase.dart';
import '../domain/usecases/load_episode_comments_usecase.dart';
import '../view/blocs/comment_post/comment_post_bloc.dart';
import '../view/blocs/comments_bloc/comments_bloc.dart';

void initiDependenciesComments() {
  final _get = GetIt.instance;

//!datasources

  _get.registerLazySingleton<NetworkCommentsDataSource>(
      () => NetworkCommentsDataSourceImpl(_get()));

//!repositories
  _get.registerLazySingleton<CommentsRepository>(
      () => CommentsRepositoryImpl(_get(), _get()));

//!usecases
  _get.registerLazySingleton<CreateNewCommentUsecase>(
      () => CreateNewCommentUsecase(_get()));

  _get.registerLazySingleton<LoadEpisodeCommentsUsecase>(
      () => LoadEpisodeCommentsUsecase(_get()));

//!blocs
  _get.registerFactory(() => CommentPostBloc(_get()));
  _get.registerFactory(() => CommentsBloc(_get()));
}
