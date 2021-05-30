import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';
import 'package:tw_shows/functions/comments/domain/usecases/create_new_comment_usecase.dart';

part 'comment_post_event.dart';
part 'comment_post_state.dart';

class CommentPostBloc extends Bloc<CommentPostEvent, CommentPostState> {
  final CreateNewCommentUsecase _createNewCommentUsecase;
  CommentPostBloc(this._createNewCommentUsecase) : super(CommentPostInitial());

  @override
  Stream<CommentPostState> mapEventToState(
    CommentPostEvent event,
  ) async* {
    yield CommentPostLoading();
    if (event is PostComment) {
      final _eitherResponse =
          await _createNewCommentUsecase(CommentParams(event.comment));
      yield _eitherResponse.fold(
        (Failure failure) => CommentPostFail(failure.message),
        (_) => CommentPostSuccess(),
      );
    }
  }
}
