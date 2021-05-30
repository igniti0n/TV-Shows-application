//@dart=2.9

import 'package:bloc_test/bloc_test.dart' as bl;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tw_shows/core/constants/error_messages.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/domain/usecases/load_show_usecase_impl.dart';
import 'package:tw_shows/functions/shows/view/blocs/single_show_bloc/single_show_bloc.dart';

class MockLoadShowUsecase extends Mock implements LoadShowUsecase {}

void main() {
  MockLoadShowUsecase _mockLoadShowUsecase;
  setUp(() {
    _mockLoadShowUsecase = MockLoadShowUsecase();
  });

  final String _testShowId = 'test_id';
  final Show _testShow = Show(
      imageUrl: 'aa',
      description: 'description',
      title: 'title',
      id: _testShowId);

  bl.blocTest(
    'shold emit [SingleShowLoading, SingleShowLoaded] with right show when success ',
    build: () {
      when(_mockLoadShowUsecase.call(ShowParams(_testShowId)))
          .thenAnswer((realInvocation) async => Right(_testShow));
      return SingleShowBloc(_mockLoadShowUsecase);
    },
    act: (bloc) => bloc.add(FetchShow(_testShowId)),
    expect: () => [SingleShowLoading(), SingleShowLoaded(_testShow)],
  );

  bl.blocTest(
    'shold emit [SingleShowLoading, SingleShowError] when ServerFailure occured with ERROR_SERVER message ',
    build: () {
      when(_mockLoadShowUsecase.call(ShowParams(_testShowId)))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));
      return SingleShowBloc(_mockLoadShowUsecase);
    },
    act: (bloc) => bloc.add(FetchShow(_testShowId)),
    expect: () => [SingleShowLoading(), SingleShowError(ERROR_SERVER)],
  );

  bl.blocTest(
    'shold emit [SingleShowLoading, SingleShowError] when NoConnectionFailure occured with ERROR_NO_CONNECTION message ',
    build: () {
      when(_mockLoadShowUsecase.call(ShowParams(_testShowId)))
          .thenAnswer((realInvocation) async => Left(NoConnectionFailure()));
      return SingleShowBloc(_mockLoadShowUsecase);
    },
    act: (bloc) => bloc.add(FetchShow(_testShowId)),
    expect: () => [SingleShowLoading(), SingleShowError(ERROR_NO_CONNECTION)],
  );
}
