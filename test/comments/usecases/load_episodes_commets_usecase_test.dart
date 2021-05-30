//@dart =2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';
import 'package:tw_shows/functions/comments/domain/repositories/comments_repository.dart';
import 'package:tw_shows/functions/comments/domain/usecases/load_episode_comments_usecase.dart';

class MockCommentsRepository extends Mock implements CommentsRepository {}

void main() {
  MockCommentsRepository _mockCommentsRepository;
  LoadEpisodeCommentsUsecase _loadEpisodeCommentsUsecase;

  setUp(() {
    _mockCommentsRepository = MockCommentsRepository();
    _loadEpisodeCommentsUsecase =
        LoadEpisodeCommentsUsecase(_mockCommentsRepository);
  });

  final String _testEpisodeId = 'episode_id';

  final List<Comment> _testComments = [Comment('text', 'epId')];

  test(
    'should call .getEpisodeComments from repository',
    () async {
      // arrange
      when(_mockCommentsRepository.getEpisodeComments(_testEpisodeId))
          .thenAnswer((_) async => _testComments);
      // act
      await _loadEpisodeCommentsUsecase(CommentsParams(_testEpisodeId));
      // assert
      verify(_mockCommentsRepository.getEpisodeComments(_testEpisodeId))
          .called(1);
      verifyNoMoreInteractions(_mockCommentsRepository);
    },
  );

  test(
    'should call return correct list of comments if all goes well',
    () async {
      // arrange
      when(_mockCommentsRepository.getEpisodeComments(_testEpisodeId))
          .thenAnswer((_) async => _testComments);
      // act
      final _res =
          await _loadEpisodeCommentsUsecase(CommentsParams(_testEpisodeId));
      // assert
      expect(_res, Right(_testComments));
    },
  );

  test(
    'should call return NoConnectionFailure when NoConnectionException occures',
    () async {
      // arrange
      when(_mockCommentsRepository.getEpisodeComments(_testEpisodeId))
          .thenThrow(NoConnectionException());
      // act
      final _res =
          await _loadEpisodeCommentsUsecase(CommentsParams(_testEpisodeId));
      // assert
      expect(_res, Left(NoConnectionFailure()));
    },
  );

  test(
    'should call return ServerFailure when fetching comments goes wrong',
    () async {
      // arrange
      when(_mockCommentsRepository.getEpisodeComments(_testEpisodeId))
          .thenThrow(ServerException());
      // act
      final _res =
          await _loadEpisodeCommentsUsecase(CommentsParams(_testEpisodeId));
      // assert
      expect(_res, Left(ServerFailure()));
    },
  );
}
