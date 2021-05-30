//@dart =2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';
import 'package:tw_shows/functions/comments/domain/repositories/comments_repository.dart';
import 'package:tw_shows/functions/comments/domain/usecases/create_new_comment_usecase.dart';

class MockCommentsRepository extends Mock implements CommentsRepository {}

void main() {
  MockCommentsRepository _mockCommentsRepository;
  CreateNewCommentUsecase _createNewCommentUsecase;

  setUp(() {
    _mockCommentsRepository = MockCommentsRepository();
    _createNewCommentUsecase = CreateNewCommentUsecase(_mockCommentsRepository);
  });

  final Comment _testComm = Comment('text', 'epId');

  test(
    'should call .getEpisodeComments from repository',
    () async {
      // arrange
      when(_mockCommentsRepository.createNewComment(_testComm))
          .thenAnswer((_) async => null);
      // act
      await _createNewCommentUsecase(CommentParams(_testComm));
      // assert
      verify(_mockCommentsRepository.createNewComment(_testComm)).called(1);
      verifyNoMoreInteractions(_mockCommentsRepository);
    },
  );

  test(
    'should call return correct list of comments if all goes well',
    () async {
      // arrange
      when(_mockCommentsRepository.createNewComment(_testComm))
          .thenAnswer((_) async => null);
      // act
      final _res = await _createNewCommentUsecase(CommentParams(_testComm));
      // assert
      expect(_res.isRight(), true);
    },
  );

  test(
    'should call return NoConnectionFailure when NoConnectionException occures',
    () async {
      // arrange
      when(_mockCommentsRepository.createNewComment(_testComm))
          .thenThrow(NoConnectionException());
      // act
      final _res = await _createNewCommentUsecase(CommentParams(_testComm));
      // assert
      expect(_res, Left(NoConnectionFailure()));
    },
  );

  test(
    'should call return ServerFailure when fetching comments goes wrong',
    () async {
      // arrange
      when(_mockCommentsRepository.createNewComment(_testComm))
          .thenThrow(ServerException());
      // act
      final _res = await _createNewCommentUsecase(CommentParams(_testComm));
      // assert
      expect(_res, Left(ServerFailure()));
    },
  );
}
