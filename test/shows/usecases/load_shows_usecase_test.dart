//@dart=2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/functions/shows/domain/usecases/load_shows_usecase_impl.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/domain/repositories/shows_repository.dart';

class MockShowsRepository extends Mock implements ShowsRepository {}

void main() {
  MockShowsRepository _mockShowsRepository;
  LoadShowsUsecase _loadShowsUsecaseImpl;

  setUp(() {
    _mockShowsRepository = MockShowsRepository();
    _loadShowsUsecaseImpl = LoadShowsUsecase(_mockShowsRepository);
  });

  test(
    'should call fetch methos on the repository',
    () async {
      // arrange

      // act
      await _loadShowsUsecaseImpl.call(NoParams());

      // assert
      verify(_mockShowsRepository.fetchAllShows()).called(1);
    },
  );

  final List<Show> _testShows = [
    Show(description: 'desc', id: 'id', imageUrl: 'url', title: 'title'),
    Show(description: 'descc', id: 'idd', imageUrl: 'urll', title: 'titlee'),
  ];

  test(
    'should return list fo shows when all goes well',
    () async {
      // arrange
      when(_mockShowsRepository.fetchAllShows())
          .thenAnswer((_) async => _testShows);
      // act
      final _res = await _loadShowsUsecaseImpl.call(NoParams());
      // assert
      expect(_res, Right(_testShows));
    },
  );

  test(
    'should return NoConnectionFailure when NoConnectionException occurs',
    () async {
      // arrange
      when(_mockShowsRepository.fetchAllShows())
          .thenThrow(NoConnectionException());
      // act
      final _res = await _loadShowsUsecaseImpl.call(NoParams());
      // assert
      expect(_res, Left(NoConnectionFailure()));
    },
  );

  test(
    'should return ServerFailure when fetching of shows goes wrong',
    () async {
      // arrange
      when(_mockShowsRepository.fetchAllShows()).thenThrow(ServerException());
      // act
      final _res = await _loadShowsUsecaseImpl.call(NoParams());
      // assert
      expect(_res, Left(ServerFailure()));
    },
  );
}
