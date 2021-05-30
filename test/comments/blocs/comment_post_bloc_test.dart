//@dart=2.9

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart' as bl;
import 'package:mockito/mockito.dart';
import 'package:tw_shows/core/constants/error_messages.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/functions/comments/data/enteties/comment_model.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';
import 'package:tw_shows/functions/comments/domain/usecases/create_new_comment_usecase.dart';
import 'package:tw_shows/functions/comments/domain/usecases/load_episode_comments_usecase.dart';
import 'package:tw_shows/functions/comments/view/blocs/comment_post/comment_post_bloc.dart';
import 'package:tw_shows/functions/comments/view/blocs/comments_bloc/comments_bloc.dart';

import '../../fixtures_parser.dart';

class MockCreateNewCommentUsecase extends Mock
    implements CreateNewCommentUsecase {}

void main() {
  MockCreateNewCommentUsecase _mockCreateNewCommentUsecase;

  final CommentModel _testCommentModel = CommentModel('text', 'epId');
  final Comment _testComm = _testCommentModel;
  final String _testEpisodeId = 'episode_id';

  bl.blocTest(
    'should call usecase',
    build: () {
      _mockCreateNewCommentUsecase = MockCreateNewCommentUsecase();
      return CommentPostBloc(_mockCreateNewCommentUsecase);
    },
    act: (CommentPostBloc bloc) => bloc.add(PostComment(_testComm)),
    verify: (bloc) =>
        verify(_mockCreateNewCommentUsecase(CommentParams(_testComm)))
            .called(1),
  );

  bl.blocTest(
    'should emit [CommentPostLoading(), CommentPostSuccess()] when successful',
    build: () {
      _mockCreateNewCommentUsecase = MockCreateNewCommentUsecase();

      when(_mockCreateNewCommentUsecase(CommentParams(_testComm)))
          .thenAnswer((_) async => Right(NoParams()));
      return CommentPostBloc(_mockCreateNewCommentUsecase);
    },
    act: (CommentPostBloc bloc) => bloc.add(PostComment(_testComm)),
    expect: () => [CommentPostLoading(), CommentPostSuccess()],
  );

  bl.blocTest(
    'should emit [CommentPostLoading(), CommentPostFail()] with ERR_SERVER when ServerFailure',
    build: () {
      _mockCreateNewCommentUsecase = MockCreateNewCommentUsecase();

      when(_mockCreateNewCommentUsecase(CommentParams(_testComm)))
          .thenAnswer((_) async => Left(ServerFailure()));
      return CommentPostBloc(_mockCreateNewCommentUsecase);
    },
    act: (CommentPostBloc bloc) => bloc.add(PostComment(_testComm)),
    expect: () => [CommentPostLoading(), CommentPostFail(ERROR_SERVER)],
  );

  bl.blocTest(
    'should emit [CommentPostLoading(), CommentPostFail()] with ERR_NO_CONNECTION when NoConnectionFailure',
    build: () {
      _mockCreateNewCommentUsecase = MockCreateNewCommentUsecase();

      when(_mockCreateNewCommentUsecase(CommentParams(_testComm)))
          .thenAnswer((_) async => Left(NoConnectionFailure()));
      return CommentPostBloc(_mockCreateNewCommentUsecase);
    },
    act: (CommentPostBloc bloc) => bloc.add(PostComment(_testComm)),
    expect: () => [CommentPostLoading(), CommentPostFail(ERROR_NO_CONNECTION)],
  );
}
