//@dart=2.9

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/constants/networking.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/network_client.dart';
import 'package:tw_shows/functions/comments/data/datasource/network_comments_data_source.dart';
import 'package:tw_shows/functions/comments/data/enteties/comment_model.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';

import '../../fixtures_parser.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

class MockDio extends Mock implements Dio {}

void main() {
  MockNetworkClient _mockNetworkClient;
  MockDio _mockDio;
  NetworkCommentsDataSourceImpl _networkCommentsDataSource;

  setUp(() {
    _mockDio = MockDio();
    _mockNetworkClient = MockNetworkClient();
    _networkCommentsDataSource =
        NetworkCommentsDataSourceImpl(_mockNetworkClient);
  });

  final CommentModel _testCommentModel = CommentModel('text', 'epId');
  final String _testEpisodeId = 'episode_id';

  final Map<String, dynamic> _testCommentsData =
      jsonDecode(readFile('comments'));

  final List<Map<String, dynamic>> _testCommentsDataList =
      (_testCommentsData['data'] as List<dynamic>).cast<Map<String, dynamic>>();

  final Response _testResponseFail = Response(
    data: {},
    statusCode: 400,
    requestOptions: RequestOptions(path: 'testPath'),
  );

  group('creating new comment', () {
    final Response _testResponse = Response(
      data: {},
      statusCode: 201,
      requestOptions: RequestOptions(path: 'testPath'),
    );

    test(
      'should should call .post with right addres on network client dio',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.post(
          ADDR_BASE + 'comments',
          data: _testCommentModel.toJson(),
        )).thenAnswer((_) async => _testResponse);
        // act
        await _networkCommentsDataSource.createNewComment(_testCommentModel);

        // assert
        verify(_mockDio.post(
          ADDR_BASE + 'comments',
          data: _testCommentModel.toJson(),
        )).called(1);
        verifyNoMoreInteractions(_mockDio);
      },
    );

    test(
      'should should throw ServerException when reposnse code is not 201',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.post(
          ADDR_BASE + 'comments',
          data: _testCommentModel.toJson(),
        )).thenAnswer((_) async => _testResponseFail);

        // act
        final _call =
            _networkCommentsDataSource.createNewComment(_testCommentModel);
        // assert
        expect(_call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('fetching comments for an episode', () {
    final Response _testResponse = Response(
        data: _testCommentsData,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'testPath'));

    test(
      'should should call .get with right addres on network client dio',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio
                .get(ADDR_BASE + 'episodes/' + _testEpisodeId + '/comments'))
            .thenAnswer((_) async => _testResponse);

        // act
        await _networkCommentsDataSource.getEpisodeComments(_testEpisodeId);

        // assert
        verify(_mockDio
                .get(ADDR_BASE + 'episodes/' + _testEpisodeId + '/comments'))
            .called(1);
        verifyNoMoreInteractions(_mockDio);
      },
    );

    test(
      'should return correct data when fetching goes well',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio
                .get(ADDR_BASE + 'episodes/' + _testEpisodeId + '/comments'))
            .thenAnswer((_) async => _testResponse);

        // act
        final _res =
            await _networkCommentsDataSource.getEpisodeComments(_testEpisodeId);

        // assert
        expect(_res, _testCommentsDataList);
      },
    );

    test(
      'should should throw ServerException when reposnse code is not 200',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio
                .get(ADDR_BASE + 'episodes/' + _testEpisodeId + '/comments'))
            .thenAnswer((_) async => _testResponseFail);

        // act
        final _call =
            _networkCommentsDataSource.getEpisodeComments(_testEpisodeId);

        // assert
        expect(_call, throwsA(isA<ServerException>()));
      },
    );
  });
}
