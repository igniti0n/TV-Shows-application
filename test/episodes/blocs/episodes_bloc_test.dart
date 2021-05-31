//@dart=2.9

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart' as bl;
import 'package:mockito/mockito.dart';
import 'package:tw_shows/core/constants/error_messages.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/functions/episodes/data/enteties/episode_model.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episodes_bloc/episodes_bloc.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/load_show_episodes_usecase.dart';

import '../../fixtures_parser.dart';

class MockLoadShowEpisodesUsecase extends Mock
    implements LoadShowEpisodesUsecase {}

void main() {
  MockLoadShowEpisodesUsecase _mockLoadShowsUsecase;

  final String _testShowId = 'show_id';

  final List<Map<String, dynamic>> _testDataEpisodes =
      (jsonDecode(readFile('episodes'))['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
  final List<Episode> _testShowEpisodes =
      _testDataEpisodes.map((e) => EpisodeModel.fromJson(e)).toList();

  bl.blocTest(
    'should call usecase',
    build: () {
      _mockLoadShowsUsecase = MockLoadShowEpisodesUsecase();
      return EpisodesBloc(_mockLoadShowsUsecase);
    },
    act: (EpisodesBloc bloc) => bloc.add(FetchShowEpisodes(_testShowId)),
    verify: (bloc) =>
        verify(_mockLoadShowsUsecase(EpisodesParams(_testShowId))).called(1),
  );

  bl.blocTest(
    'should emit [EpisodesLoading, EpisodesLoaded] when all goes well',
    build: () {
      _mockLoadShowsUsecase = MockLoadShowEpisodesUsecase();
      when(_mockLoadShowsUsecase.call(EpisodesParams(_testShowId)))
          .thenAnswer((_) async => Right(_testShowEpisodes));
      return EpisodesBloc(_mockLoadShowsUsecase);
    },
    act: (EpisodesBloc bloc) => bloc.add(FetchShowEpisodes(_testShowId)),
    expect: () => [EpisodesLoading(), EpisodesLoaded(_testShowEpisodes)],
  );

  bl.blocTest(
    'should emit [EpisodesLoading, EpisodesError] with ERR_SERVER message when ServerFailure',
    build: () {
      _mockLoadShowsUsecase = MockLoadShowEpisodesUsecase();
      when(_mockLoadShowsUsecase.call(EpisodesParams(_testShowId)))
          .thenAnswer((_) async => Left(ServerFailure()));
      return EpisodesBloc(_mockLoadShowsUsecase);
    },
    act: (EpisodesBloc bloc) => bloc.add(FetchShowEpisodes(_testShowId)),
    expect: () => [EpisodesLoading(), EpisodesError(ERROR_SERVER)],
  );

  bl.blocTest(
    'should emit [EpisodesLoading, EpisodesError] with ERR_NO_CONECTION message when NoConnectionFailure',
    build: () {
      _mockLoadShowsUsecase = MockLoadShowEpisodesUsecase();
      when(_mockLoadShowsUsecase.call(EpisodesParams(_testShowId)))
          .thenAnswer((_) async => Left(NoConnectionFailure()));
      return EpisodesBloc(_mockLoadShowsUsecase);
    },
    act: (EpisodesBloc bloc) => bloc.add(FetchShowEpisodes(_testShowId)),
    expect: () => [EpisodesLoading(), EpisodesError(ERROR_NO_CONNECTION)],
  );
}
