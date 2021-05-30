//@dart=2.9

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart' as bl;
import 'package:mockito/mockito.dart';
import 'package:tw_shows/core/constants/error_messages.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/functions/comments/data/enteties/comment_model.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';
import 'package:tw_shows/functions/comments/domain/usecases/load_episode_comments_usecase.dart';
import 'package:tw_shows/functions/comments/view/blocs/comments_bloc/comments_bloc.dart';

import '../../fixtures_parser.dart';

class MockLoadEpisodeCommentsUsecase extends Mock
    implements LoadEpisodeCommentsUsecase {}

void main() {
  MockLoadEpisodeCommentsUsecase _mockLoadEpisodeCommentsUsecase;

  final String _testEpiosdeId = 'episode_ID';
  final List<Map<String, dynamic>> _testCommentsData =
      (jsonDecode(readFile('comments'))['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

  final List<Comment> _testComments =
      _testCommentsData.map((e) => CommentModel.fromJson(e)).toList();

  bl.blocTest(
    'should call usecase',
    build: () {
      _mockLoadEpisodeCommentsUsecase = MockLoadEpisodeCommentsUsecase();
      return CommentsBloc(_mockLoadEpisodeCommentsUsecase);
    },
    act: (CommentsBloc bloc) => bloc.add(FetchComments(_testEpiosdeId)),
    verify: (bloc) =>
        verify(_mockLoadEpisodeCommentsUsecase(CommentsParams(_testEpiosdeId)))
            .called(1),
  );

  bl.blocTest(
    'should emit [CommentsLoading(), CommentsLoaded()] with right comments when success',
    build: () {
      _mockLoadEpisodeCommentsUsecase = MockLoadEpisodeCommentsUsecase();
      when(_mockLoadEpisodeCommentsUsecase(CommentsParams(_testEpiosdeId)))
          .thenAnswer((_) async => Right(_testComments));
      return CommentsBloc(_mockLoadEpisodeCommentsUsecase);
    },
    act: (CommentsBloc bloc) => bloc.add(FetchComments(_testEpiosdeId)),
    expect: () => [CommentsLoading(), CommentsLoaded(_testComments)],
  );

  bl.blocTest(
    'should emit [CommentsLoading(), CommentsError()] with ERR_SERVER when ServerFailure',
    build: () {
      _mockLoadEpisodeCommentsUsecase = MockLoadEpisodeCommentsUsecase();
      when(_mockLoadEpisodeCommentsUsecase(CommentsParams(_testEpiosdeId)))
          .thenAnswer((_) async => Left(ServerFailure()));
      return CommentsBloc(_mockLoadEpisodeCommentsUsecase);
    },
    act: (CommentsBloc bloc) => bloc.add(FetchComments(_testEpiosdeId)),
    expect: () => [CommentsLoading(), CommentsError(ERROR_SERVER)],
  );

  bl.blocTest(
    'should emit [CommentsLoading(), CommentsError()] with ERR_NO_CONNECTION when NoConnectionFailure',
    build: () {
      _mockLoadEpisodeCommentsUsecase = MockLoadEpisodeCommentsUsecase();
      when(_mockLoadEpisodeCommentsUsecase(CommentsParams(_testEpiosdeId)))
          .thenAnswer((_) async => Left(NoConnectionFailure()));
      return CommentsBloc(_mockLoadEpisodeCommentsUsecase);
    },
    act: (CommentsBloc bloc) => bloc.add(FetchComments(_testEpiosdeId)),
    expect: () => [CommentsLoading(), CommentsError(ERROR_NO_CONNECTION)],
  );
}
