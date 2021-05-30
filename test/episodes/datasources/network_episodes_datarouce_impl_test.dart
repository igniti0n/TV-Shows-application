//@dart=2.9

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/constants/networking.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/network_client.dart';
import 'package:tw_shows/functions/episodes/data/datasources/network_episodes_data_source.dart';
import 'package:tw_shows/functions/episodes/data/enteties/episode_model.dart';

import '../../fixtures_parser.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

class MockDio extends Mock implements Dio {}

void main() {
  MockNetworkClient _mockNetworkClient;
  MockDio _mockDio;
  NetworkEpisodesDataSourceImpl _networkEpisodesDataSource;

  setUp(() {
    _mockDio = MockDio();
    _mockNetworkClient = MockNetworkClient();
    _networkEpisodesDataSource =
        NetworkEpisodesDataSourceImpl(_mockNetworkClient);
  });

  final String _testEpisodeId = 'test_id';

  final String _testShowId = 'test_id';

  final Map<String, dynamic> _testDataSingleEpisode =
      jsonDecode(readFile('single_episode'));

  final EpisodeModel _testEpisode =
      EpisodeModel.fromJson(_testDataSingleEpisode['data']);

  final Response _testResponseFail = Response(
    data: {},
    statusCode: 400,
    requestOptions: RequestOptions(path: 'testPath'),
  );

  group('creating new episode', () {
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
          ADDR_BASE + 'episodes/',
          data: _testEpisode.toJson(),
        )).thenAnswer((_) async => _testResponse);
        // act
        await _networkEpisodesDataSource.createNewEpisode(_testEpisode);

        // assert
        verify(_mockDio.post(
          ADDR_BASE + 'episodes/',
          data: _testEpisode.toJson(),
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
          ADDR_BASE + 'episodes/',
          data: _testEpisode.toJson(),
        )).thenAnswer((_) async => _testResponseFail);

        // act
        final _call = _networkEpisodesDataSource.createNewEpisode(_testEpisode);

        // assert
        expect(_call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('fetching an episode', () {
    final Response _testResponse = Response(
        data: _testDataSingleEpisode,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'testPath'));

    test(
      'should should call .get with right addres on network client dio',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.get(ADDR_BASE + 'episodes/' + _testEpisodeId))
            .thenAnswer((_) async => _testResponse);

        // act
        await _networkEpisodesDataSource.fetchEpisode(_testEpisodeId);

        // assert
        verify(_mockDio.get(ADDR_BASE + 'episodes/' + _testEpisodeId))
            .called(1);
        verifyNoMoreInteractions(_mockDio);
      },
    );

    test(
      'should return correct data when fetching goes well',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.get(ADDR_BASE + 'episodes/' + _testEpisodeId))
            .thenAnswer((_) async => _testResponse);

        // act
        final _res =
            await _networkEpisodesDataSource.fetchEpisode(_testEpisodeId);

        // assert
        expect(_res, _testDataSingleEpisode);
      },
    );

    test(
      'should should throw ServerException when reposnse code is not 200',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.get(ADDR_BASE + 'episodes/' + _testEpisodeId))
            .thenAnswer((_) async => _testResponseFail);

        // act
        final _call = _networkEpisodesDataSource.fetchEpisode(_testEpisodeId);

        // assert
        expect(_call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('fetsh show episodes', () {
    final Map<String, dynamic> _testDataEpisodes =
        jsonDecode(readFile('episodes'));

    final List<Map<String, dynamic>> _testReturnDataEpisodes =
        (_testDataEpisodes['data'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

    final Response _testResponse = Response(
        data: _testDataEpisodes,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'testPath'));

    test(
      'should should call .get with right addres on network client dio',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.get(ADDR_BASE + 'shows/' + _testShowId + '/episodes'))
            .thenAnswer((_) async => _testResponse);

        // act
        await _networkEpisodesDataSource.fetchShowEpisodes(_testShowId);

        // assert
        verify(_mockDio.get(ADDR_BASE + 'shows/' + _testShowId + '/episodes'))
            .called(1);
        verifyNoMoreInteractions(_mockDio);
      },
    );

    test(
      'should return correct data when fetching goes well',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.get(ADDR_BASE + 'shows/' + _testShowId + '/episodes'))
            .thenAnswer((_) async => _testResponse);

        // act
        final _res =
            await _networkEpisodesDataSource.fetchShowEpisodes(_testShowId);
        // assert
        expect(_res, _testReturnDataEpisodes);
      },
    );

    test(
      'should should throw ServerException when reposnse code is not 200',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.get(ADDR_BASE + 'shows/' + _testShowId + '/episodes'))
            .thenAnswer((_) async => _testResponseFail);

        // act
        final _call = _networkEpisodesDataSource.fetchShowEpisodes(_testShowId);

        // assert
        expect(_call, throwsA(isA<ServerException>()));
      },
    );
  });
}
