//@dart = 2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/domain/repositories/episodes_repository.dart';
import 'package:tw_shows/functions/episodes/view/usecases/load_show_episodes_usecase.dart';

class MockEpisodesRepository extends Mock implements EpisodesRepository {}

void main() {
  LoadShowEpisodesUsecase _loadShowEpisodesUsecase;
  MockEpisodesRepository _mockEpisodesRepository;
  setUp(() {
    _mockEpisodesRepository = MockEpisodesRepository();
    _loadShowEpisodesUsecase = LoadShowEpisodesUsecase(_mockEpisodesRepository);
  });

  final String _testShowId = 'test_id';
  final List<Episode> _testEpisodes = [
    Episode(
      description: 'description',
      imageUrl: 'imageUrl',
      title: 'title',
      seasonNumber: 'seasonNumber',
      episodeNumber: 'episodeNumber',
      id: 'id',
      showId: 'showId',
    ),
  ];

  test(
    'should call .fetchShowEpisodes() on EpisodesRepository and no more interactions',
    () async {
      // arrange

      // act
      await _loadShowEpisodesUsecase.call(EpisodesParams(_testShowId));

      // assert
      verify(_mockEpisodesRepository.fetchShowEpisodes(_testShowId)).called(1);
      verifyNoMoreInteractions(_mockEpisodesRepository);
    },
  );

  test(
    'should return shows episodes when all goes correct',
    () async {
      // arrange
      when(_mockEpisodesRepository.fetchShowEpisodes(_testShowId))
          .thenAnswer((_) async => _testEpisodes);
      // act
      final _res =
          await _loadShowEpisodesUsecase.call(EpisodesParams(_testShowId));

      // assert
      expect(_res, Right(_testEpisodes));
    },
  );

  test(
    'should return NoConnectionFailure when NoConnectionException occurred',
    () async {
      // arrange
      when(_mockEpisodesRepository.fetchShowEpisodes(_testShowId))
          .thenThrow(NoConnectionException());
      // act
      final _res =
          await _loadShowEpisodesUsecase.call(EpisodesParams(_testShowId));

      // assert
      expect(_res, Left(NoConnectionFailure()));
    },
  );

  test(
    'should return ServerFailure when fetching went wrong',
    () async {
      // arrange
      when(_mockEpisodesRepository.fetchShowEpisodes(_testShowId))
          .thenThrow(ServerException());
      // act
      final _res =
          await _loadShowEpisodesUsecase.call(EpisodesParams(_testShowId));

      // assert
      expect(_res, Left(ServerFailure()));
    },
  );
}
