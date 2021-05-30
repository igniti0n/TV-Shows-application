//@dart=2.9

import 'dart:convert';
import 'dart:math';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/connection_checker.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/functions/comments/data/datasource/network_comments_data_source.dart';
import 'package:tw_shows/functions/comments/data/enteties/comment_model.dart';
import 'package:tw_shows/functions/comments/data/repositories/comments_repository_impl.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';

import '../../fixtures_parser.dart';

class MockNetworkCommentsDataSource extends Mock
    implements NetworkCommentsDataSource {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

void main() {
  MockNetworkCommentsDataSource _mockNetworkCommentsDataSource;
  MockConnectionChecker _mockConnectionChecker;

  CommentsRepositoryImpl _commentsRepositoryImpl;

  setUp(() {
    _mockNetworkCommentsDataSource = MockNetworkCommentsDataSource();
    _mockConnectionChecker = MockConnectionChecker();
    _commentsRepositoryImpl = CommentsRepositoryImpl(
        _mockNetworkCommentsDataSource, _mockConnectionChecker);
  });

  final CommentModel _testCommentModel = CommentModel('text', 'epId');
  final Comment _testComm = _testCommentModel;
  final String _testEpisodeId = 'episode_id';

  final List<Map<String, dynamic>> _testCommentsData =
      (jsonDecode(readFile('comments'))['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

  final List<Comment> _testComments =
      _testCommentsData.map((e) => CommentModel.fromJson(e)).toList();

  _setUpConnection(bool isConnected) {
    when(_mockConnectionChecker.hasConnection)
        .thenAnswer((_) async => isConnected);
  }

  group('creating a new comment', () {
    _setUpCreatingCommentSuccess() {
      when(_mockNetworkCommentsDataSource.createNewComment(_testCommentModel))
          .thenAnswer((realInvocation) async => NoParams());
    }

    test(
      'should check if there is connection',
      () async {
        // arrange
        _setUpConnection(true);
        _setUpCreatingCommentSuccess();

        // act
        await _commentsRepositoryImpl.createNewComment(_testComm);

        // assert
        verify(_mockConnectionChecker.hasConnection).called(1);
        verifyNoMoreInteractions(_mockConnectionChecker);
      },
    );

    test(
      'should throw NoConnectionException if device not connected to the internet',
      () async {
        // arrange
        _setUpConnection(false);
        _setUpCreatingCommentSuccess();
        // act
        final _call = _commentsRepositoryImpl.createNewComment(_testComm);

        // assert
        expect(_call, throwsA(isA<NoConnectionException>()));
      },
    );

    test(
      'should call .createComment with rightCommentModel on NetworkCommentsDataSource',
      () async {
        // arrange
        _setUpConnection(true);
        _setUpCreatingCommentSuccess();
        // act
        await _commentsRepositoryImpl.createNewComment(_testComm);

        // assert
        verify(_mockNetworkCommentsDataSource
                .createNewComment(_testCommentModel))
            .called(1);
        verifyNoMoreInteractions(_mockNetworkCommentsDataSource);
      },
    );
  });

  group('fetching episode comments', () {
    _setUpFetchingCommentsSuccess() {
      when(_mockNetworkCommentsDataSource.getEpisodeComments(_testEpisodeId))
          .thenAnswer((realInvocation) async => _testCommentsData);
    }

    test(
      'should check if there is connection',
      () async {
        // arrange
        _setUpConnection(true);
        _setUpFetchingCommentsSuccess();

        // act
        await _commentsRepositoryImpl.getEpisodeComments(_testEpisodeId);

        // assert
        verify(_mockConnectionChecker.hasConnection).called(1);
        verifyNoMoreInteractions(_mockConnectionChecker);
      },
    );

    test(
      'should throw NoConnectionException if device not connected to the internet',
      () async {
        // arrange
        _setUpConnection(false);
        _setUpFetchingCommentsSuccess(); // act
        final _call =
            _commentsRepositoryImpl.getEpisodeComments(_testEpisodeId);

        // assert
        expect(_call, throwsA(isA<NoConnectionException>()));
      },
    );

    test(
      'should call .getEpisodeComments with right episodeId',
      () async {
        // arrange
        _setUpConnection(true);
        _setUpFetchingCommentsSuccess();
        // act
        await _commentsRepositoryImpl.getEpisodeComments(_testEpisodeId);

        // assert
        verify(_mockNetworkCommentsDataSource
              ..getEpisodeComments(_testEpisodeId))
            .called(1);
        verifyNoMoreInteractions(_mockNetworkCommentsDataSource);
      },
    );

    test(
      'should return correct list of Comments from comments data',
      () async {
        // arrange
        _setUpConnection(true);
        _setUpFetchingCommentsSuccess();
        // act
        final _res =
            await _commentsRepositoryImpl.getEpisodeComments(_testEpisodeId);

        // assert
        expect(_res, _testComments);
      },
    );
  });
}
