//@dart=2.9

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart' as bl;
import 'package:mockito/mockito.dart';
import 'package:tw_shows/core/constants/error_messages.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/functions/episodes/data/enteties/episode_model.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episodes_bloc/episodes_bloc.dart';
import 'package:tw_shows/functions/episodes/view/blocs/single_episode_bloc/single_episode_bloc.dart';
import 'package:tw_shows/functions/episodes/view/usecases/load_episode_usecase.dart';
import 'package:tw_shows/functions/episodes/view/usecases/load_show_episodes_usecase.dart';

import 'package:tw_shows/functions/shows/view/blocs/shows_bloc/shows_bloc.dart';

import '../../fixtures_parser.dart';

class MockLoadEpisodeUsecase extends Mock implements LoadEpisodeUsecase {}

void main() {
  MockLoadEpisodeUsecase _mockLoadEpisodeUsecase;

  final List<Episode> _testShows = [
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

  final String _testEpisodeId = 'episode_id';
  final Episode _testEpisode =
      EpisodeModel.fromJson(jsonDecode(readFile('single_episode')));

  bl.blocTest(
    'should call usecase',
    build: () {
      _mockLoadEpisodeUsecase = MockLoadEpisodeUsecase();
      when(_mockLoadEpisodeUsecase.call(EpisodeParams(_testEpisodeId)))
          .thenAnswer((_) async => Right(_testEpisode));
      return SingleEpisodeBloc(_mockLoadEpisodeUsecase);
    },
    act: (SingleEpisodeBloc bloc) => bloc.add(FetchEpisode(_testEpisodeId)),
    verify: (bloc) =>
        verify(_mockLoadEpisodeUsecase(EpisodeParams(_testEpisodeId)))
            .called(1),
  );

  bl.blocTest(
    'should emit [SingleEpisodeLoading(), SingleEpisodeLoaded()] with correct episode when success',
    build: () {
      _mockLoadEpisodeUsecase = MockLoadEpisodeUsecase();
      when(_mockLoadEpisodeUsecase.call(EpisodeParams(_testEpisodeId)))
          .thenAnswer((_) async => Right(_testEpisode));
      return SingleEpisodeBloc(_mockLoadEpisodeUsecase);
    },
    act: (SingleEpisodeBloc bloc) => bloc.add(FetchEpisode(_testEpisodeId)),
    expect: () => [SingleEpisodeLoading(), SingleEpisodeLoaded(_testEpisode)],
  );

  bl.blocTest(
    'should emit [SingleEpisodeLoading(), SingleEpisodeError()] with ERR_SERVER message when ServerFailure',
    build: () {
      _mockLoadEpisodeUsecase = MockLoadEpisodeUsecase();
      when(_mockLoadEpisodeUsecase.call(EpisodeParams(_testEpisodeId)))
          .thenAnswer((_) async => Left(ServerFailure()));
      return SingleEpisodeBloc(_mockLoadEpisodeUsecase);
    },
    act: (SingleEpisodeBloc bloc) => bloc.add(FetchEpisode(_testEpisodeId)),
    expect: () => [SingleEpisodeLoading(), SingleEpisodeError(ERROR_SERVER)],
  );

  bl.blocTest(
    'should emit [SingleEpisodeLoading(), SingleEpisodeError()] with ERR_SERVER message when ServerFailure',
    build: () {
      _mockLoadEpisodeUsecase = MockLoadEpisodeUsecase();
      when(_mockLoadEpisodeUsecase.call(EpisodeParams(_testEpisodeId)))
          .thenAnswer((_) async => Left(NoConnectionFailure()));
      return SingleEpisodeBloc(_mockLoadEpisodeUsecase);
    },
    act: (SingleEpisodeBloc bloc) => bloc.add(FetchEpisode(_testEpisodeId)),
    expect: () =>
        [SingleEpisodeLoading(), SingleEpisodeError(ERROR_NO_CONNECTION)],
  );
}
