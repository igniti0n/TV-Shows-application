import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';
import 'package:tw_shows/functions/comments/domain/usecases/load_episode_comments_usecase.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final LoadEpisodeCommentsUsecase _loadEpisodeCommentsUsecase;
  CommentsBloc(this._loadEpisodeCommentsUsecase) : super(CommentsInitial());

  @override
  Stream<CommentsState> mapEventToState(
    CommentsEvent event,
  ) async* {
    yield CommentsLoading();
    if (event is FetchComments) {
      final _responseEither =
          await _loadEpisodeCommentsUsecase(CommentsParams(event.episodeId));
      yield _responseEither.fold(
        (Failure failure) => CommentsError(failure.message),
        (List<Comment> comments) => CommentsLoaded(comments),
      );
    }
  }
}
