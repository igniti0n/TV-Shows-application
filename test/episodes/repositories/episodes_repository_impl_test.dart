//@dart=2.9

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/connection_checker.dart';
import 'package:tw_shows/functions/episodes/data/datasources/network_episodes_data_source.dart';
import 'package:tw_shows/functions/episodes/data/enteties/episode_model.dart';
import 'package:tw_shows/functions/episodes/data/repositories/episodes_repository_impl.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';

import '../../fixtures_parser.dart';

class MockNetworkEpisodesDataSource extends Mock
    implements NetworkEpisodesDataSource {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

void main() {
  MockConnectionChecker _mockConnectionChecker;
  MockNetworkEpisodesDataSource _mockNetworkEpisodesDataSource;
  EpisodesRepositoryImpl _episodesRpositoryImpl;

  setUp(() {
    _mockConnectionChecker = MockConnectionChecker();
    _mockNetworkEpisodesDataSource = MockNetworkEpisodesDataSource();
    _episodesRpositoryImpl = EpisodesRepositoryImpl(
      _mockConnectionChecker,
      _mockNetworkEpisodesDataSource,
    );
  });

  final String _testEpisodeId = 'test_id';
  final List<Map<String, dynamic>> _testDataEpisodes =
      (jsonDecode(readFile('episodes'))['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
  final Map<String, dynamic> _testDataSingleEpisode =
      jsonDecode(readFile('single_episode'));

  final Episode _testEpisode =
      EpisodeModel.fromJson(_testDataSingleEpisode['data']);
  final List<Episode> _testShowEpisodes =
      _testDataEpisodes.map((e) => EpisodeModel.fromJson(e)).toList();

  _setUpConnection(bool isConnected) {
    when(_mockConnectionChecker.hasConnection)
        .thenAnswer((_) async => isConnected);
  }

  group('fetching episode', () {
    _setUpSingleEpisodeSuccess() {
      when(_mockNetworkEpisodesDataSource.fetchEpisode(_testEpisodeId))
          .thenAnswer((realInvocation) async => _testDataSingleEpisode);
    }

    _setUpSingleEpisodeFail() {
      when(_mockNetworkEpisodesDataSource.fetchEpisode(_testEpisodeId))
          .thenThrow(ServerException());
    }

    test(
      'should check if there is connection',
      () async {
        // arrange
        _setUpSingleEpisodeSuccess();
        _setUpConnection(true);
        // act
        await _episodesRpositoryImpl.fetchEpisode(_testEpisodeId);
        // assert
        verify(_mockConnectionChecker.hasConnection).called(1);
        verifyNoMoreInteractions(_mockConnectionChecker);
      },
    );

    test(
      'should throw NoConnectionException when device not connected to internet',
      () async {
        // arrange
        when(_mockConnectionChecker.hasConnection)
            .thenThrow(NoConnectionException());
        // act
        final _call = _episodesRpositoryImpl.fetchEpisode(_testEpisodeId);
        // assert
        expect(_call, throwsA(isA<NoConnectionException>()));
      },
    );

    test(
      'should call .fetchEpisode on the NetworkEpisodesDataSource',
      () async {
        // arrange
        _setUpSingleEpisodeSuccess();
        _setUpConnection(true);
        // act
        await _episodesRpositoryImpl.fetchEpisode(_testEpisodeId);
        // assert
        verify(_mockNetworkEpisodesDataSource.fetchEpisode(_testEpisodeId))
            .called(1);
        verifyNoMoreInteractions(_mockNetworkEpisodesDataSource);
      },
    );

    test(
      'should call return correct Episode when fetching is success',
      () async {
        // arrange
        _setUpSingleEpisodeSuccess();
        _setUpConnection(true);
        // act
        final _res = await _episodesRpositoryImpl.fetchEpisode(_testEpisodeId);
        // assert
        expect(
          _res,
          _testEpisode,
        );
      },
    );
  });

  group(
    'fetching show episodes',
    () {
      final String _testShowId = '_testId';

      _setUpShowEpisodesSuccess() {
        when(_mockNetworkEpisodesDataSource.fetchShowEpisodes(_testShowId))
            .thenAnswer((_) async => _testDataEpisodes);
      }

      test(
        'should check if there is connection',
        () async {
          // arrange
          _setUpShowEpisodesSuccess();
          _setUpConnection(true);
          // act
          await _episodesRpositoryImpl.fetchShowEpisodes(_testShowId);
          // assert
          verify(_mockConnectionChecker.hasConnection).called(1);
          verifyNoMoreInteractions(_mockConnectionChecker);
        },
      );

      test(
        'should throw NoConnectionException when device not connected to internet',
        () async {
          // arrange
          when(_mockConnectionChecker.hasConnection)
              .thenThrow(NoConnectionException());
          // act
          final _call = _episodesRpositoryImpl.fetchShowEpisodes(_testShowId);
          // assert
          expect(_call, throwsA(isA<NoConnectionException>()));
        },
      );

      test(
        'should call .fetchShowEpisodes on the NetworkEpisodesDataSource',
        () async {
          // arrange
          _setUpShowEpisodesSuccess();
          _setUpConnection(true);
          // act
          await _episodesRpositoryImpl.fetchShowEpisodes(_testShowId);
          // assert
          verify(_mockNetworkEpisodesDataSource.fetchShowEpisodes(_testShowId))
              .called(1);
          verifyNoMoreInteractions(_mockNetworkEpisodesDataSource);
        },
      );

      test(
        'should return correct List of Episodes when all goes well',
        () async {
          // arrange
          _setUpShowEpisodesSuccess();
          _setUpConnection(true);
          // act
          final _res =
              await _episodesRpositoryImpl.fetchShowEpisodes(_testShowId);
          // assert
          expect(_res, _testShowEpisodes);
        },
      );
    },
  );

  group('creating episode', () {
    _setUpCreateEpisodeSuccess() {
      when(_mockNetworkEpisodesDataSource.createNewEpisode(_testEpisode))
          .thenAnswer((_) async => null);
    }

    test(
      'should check if there is connection',
      () async {
        // arrange
        _setUpCreateEpisodeSuccess();
        _setUpConnection(true);
        // act
        await _episodesRpositoryImpl.createNewEpisode(_testEpisode);
        // assert
        verify(_mockConnectionChecker.hasConnection).called(1);
        verifyNoMoreInteractions(_mockConnectionChecker);
      },
    );

    test(
      'should throw NoConnectionException when device not connected to internet',
      () async {
        // arrange
        when(_mockConnectionChecker.hasConnection)
            .thenThrow(NoConnectionException());
        // act
        final _call = _episodesRpositoryImpl.createNewEpisode(_testEpisode);
        // assert
        expect(_call, throwsA(isA<NoConnectionException>()));
      },
    );

    test(
      'should call .createNewEpisode  and .createNewEpisodeImage on the NetworkEpisodesDataSource with correct episode',
      () async {
        // arrange
        _setUpCreateEpisodeSuccess();
        _setUpConnection(true);
        // act
        await _episodesRpositoryImpl.createNewEpisode(_testEpisode);
        // assert
        verify(_mockNetworkEpisodesDataSource.createNewEpisode(_testEpisode))
            .called(1);
        verify(_mockNetworkEpisodesDataSource
                .createNewEpisodeImage(_testEpisode.imageUrl))
            .called(1);
        verifyNoMoreInteractions(_mockNetworkEpisodesDataSource);
      },
    );
  });
}
