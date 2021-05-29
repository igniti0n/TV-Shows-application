//@dart=2.9

//import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_test/bloc_test.dart' as bl;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tw_shows/core/constants/error_messages.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:dartz/dartz.dart';

import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/domain/usecases/load_shows_usecase.dart';
import 'package:tw_shows/functions/shows/view/shows_bloc/shows_bloc.dart';

class MockLoadShowsUsecase extends Mock implements LoadShowsUsecase {}

void main() {
  MockLoadShowsUsecase _mockLoadShowsUsecase;

  final List<Show> _testShows = [
    Show(description: 'desc',id: 'id',imageUrl: 'url',title: 'title'),
    Show(description: 'descc',id: 'idd',imageUrl: 'urll',title: 'titlee'),
  ];


  bl.blocTest(
    'should call usecase',
    build: () {
          _mockLoadShowsUsecase = MockLoadShowsUsecase();

      when(_mockLoadShowsUsecase(NoParams())).thenAnswer(
        (_) async => Right(_testShows),
      );
      return ShowsBloc(_mockLoadShowsUsecase);
    },
    act: (ShowsBloc bloc) => bloc.add(FetchShows()),
    verify: (bloc) => verify(_mockLoadShowsUsecase(NoParams())).called(1),
  );

  bl.blocTest(
      'should emit [LoadingShows, ShowsLoaded] when LoadShows event started and uscase success with right shows',
      build: () {
                  _mockLoadShowsUsecase = MockLoadShowsUsecase();

        when(_mockLoadShowsUsecase.call(NoParams())).thenAnswer(
          (_) async => Right(_testShows),
        );
        return ShowsBloc(_mockLoadShowsUsecase);
      },
      act: (ShowsBloc bloc) => bloc.add(FetchShows()),
      expect: () => [ShowsLoading(), ShowsLoaded(_testShows)]);

  bl.blocTest(
    'should emit [LoadingShows, ShowsError] when LoadShows event started and uscase failes with ERROR_NO_CONNECTION message',
    build: () {
      _mockLoadShowsUsecase = MockLoadShowsUsecase();
      when(_mockLoadShowsUsecase(any)).thenAnswer(
        (_) async => Left(NoConnectionFailure()),
      );
      return ShowsBloc(_mockLoadShowsUsecase);
    },
    act: (ShowsBloc bloc) => bloc.add(FetchShows()),
    expect: () => [
      ShowsLoading(),
      ShowsError(ERROR_NO_CONNECTION),
    ],
  );
}
