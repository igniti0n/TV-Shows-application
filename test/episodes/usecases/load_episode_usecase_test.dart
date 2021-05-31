//@dart = 2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/domain/repositories/episodes_repository.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/load_episode_usecase.dart';

class MockEpisodesRepository extends Mock implements EpisodesRepository {}

void main() {
  LoadEpisodeUsecase _loadShowEpisodesUsecase;
  MockEpisodesRepository _mockEpisodesRepository;
  setUp(() {
    _mockEpisodesRepository = MockEpisodesRepository();
    _loadShowEpisodesUsecase = LoadEpisodeUsecase(_mockEpisodesRepository);
  });

  final String _testEpisodeId = 'test_id';
  final Episode _testEpisode = Episode(
    description: 'description',
    imageUrl: 'imageUrl',
    title: 'title',
    seasonNumber: 'seasonNumber',
    episodeNumber: 'episodeNumber',
    id: 'id',
    showId: 'showId',
  );

  test(
    'should call .fetchEpisode() on EpisodesRepository and no more interactions',
    () async {
      // arrange

      // act
      await _loadShowEpisodesUsecase.call(EpisodeParams(_testEpisodeId));

      // assert
      verify(_mockEpisodesRepository.fetchEpisode(_testEpisodeId)).called(1);
      verifyNoMoreInteractions(_mockEpisodesRepository);
    },
  );

  test(
    'should return the episode when all goes correct',
    () async {
      // arrange
      when(_mockEpisodesRepository.fetchEpisode(_testEpisodeId))
          .thenAnswer((_) async => _testEpisode);
      // act
      final _res =
          await _loadShowEpisodesUsecase.call(EpisodeParams(_testEpisodeId));

      // assert
      expect(_res, Right(_testEpisode));
    },
  );

  test(
    'should return NoConnectionFailure when NoConnectionException occurred',
    () async {
      // arrange
      when(_mockEpisodesRepository.fetchEpisode(_testEpisodeId))
          .thenThrow(NoConnectionException());
      // act
      final _res =
          await _loadShowEpisodesUsecase.call(EpisodeParams(_testEpisodeId));

      // assert
      expect(_res, Left(NoConnectionFailure()));
    },
  );

  test(
    'should return ServerFailure when fetching went wrong',
    () async {
      // arrange
      when(_mockEpisodesRepository.fetchEpisode(_testEpisodeId))
          .thenThrow(ServerException());
      // act
      final _res =
          await _loadShowEpisodesUsecase.call(EpisodeParams(_testEpisodeId));

      // assert
      expect(_res, Left(ServerFailure()));
    },
  );
}
