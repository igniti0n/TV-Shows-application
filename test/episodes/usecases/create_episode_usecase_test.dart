//@dart = 2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/domain/repositories/episodes_repository.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/load_episode_usecase.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/create_episode_usecase.dart';

class MockEpisodesRepository extends Mock implements EpisodesRepository {}

void main() {
  CreateEpisodeUsecase _loadShowEpisodesUsecase;
  MockEpisodesRepository _mockEpisodesRepository;
  setUp(() {
    _mockEpisodesRepository = MockEpisodesRepository();
    _loadShowEpisodesUsecase = CreateEpisodeUsecase(_mockEpisodesRepository);
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
    'should call .createNewEpisode() on EpisodesRepository and no more interactions',
    () async {
      // arrange

      // act
      await _loadShowEpisodesUsecase.call(EpisodeCreateParams(_testEpisode));

      // assert
      verify(_mockEpisodesRepository.createNewEpisode(_testEpisode)).called(1);
      verifyNoMoreInteractions(_mockEpisodesRepository);
    },
  );

  test(
    'should return NoConnectionFailure when NoConnectionException occurred',
    () async {
      // arrange
      when(_mockEpisodesRepository.createNewEpisode(_testEpisode))
          .thenThrow(NoConnectionException());
      // act
      final _res = await _loadShowEpisodesUsecase
          .call(EpisodeCreateParams(_testEpisode));

      // assert
      expect(_res, Left(NoConnectionFailure()));
    },
  );

  test(
    'should return ServerFailure when fetching went wrong',
    () async {
      // arrange
      when(_mockEpisodesRepository.createNewEpisode(_testEpisode))
          .thenThrow(ServerException());
      // act
      final _res = await _loadShowEpisodesUsecase
          .call(EpisodeCreateParams(_testEpisode));

      // assert
      expect(_res, Left(ServerFailure()));
    },
  );
}
