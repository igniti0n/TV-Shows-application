//@dart=2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/shows/domain/usecases/load_show_usecase_impl.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/domain/repositories/shows_repository.dart';

class MockShowsRepository extends Mock implements ShowsRepository {}

void main() {
  MockShowsRepository _mockShowsRepository;
  LoadShowUsecase _loadShowUsecaseImpl;

  setUp(() {
    _mockShowsRepository = MockShowsRepository();
    _loadShowUsecaseImpl = LoadShowUsecase(_mockShowsRepository);
  });
  final Show _testShow =
      Show(description: 'desc', id: 'id', imageUrl: 'url', title: 'title');
  final String _testShowId = 'test_id';

  test(
    'should call fetch show method on the repository with appropriate showId',
    () async {
      // arrange

      // act
      await _loadShowUsecaseImpl.call(ShowParams(_testShowId));

      // assert
      verify(_mockShowsRepository.fetchShow(_testShowId)).called(1);
    },
  );

  test(
    'should return a show when fetching goes well',
    () async {
      // arrange
      when(_mockShowsRepository.fetchShow(_testShowId))
          .thenAnswer((_) async => _testShow);
      // act
      final _res = await _loadShowUsecaseImpl.call(ShowParams(_testShowId));

      // assert
      expect(_res, Right(_testShow));
    },
  );

  test(
    'should return NoConnectionFailure on NoConnection exception',
    () async {
      // arrange
      when(_mockShowsRepository.fetchShow(_testShowId))
          .thenThrow(NoConnectionException());
      // act
      final _res = await _loadShowUsecaseImpl.call(ShowParams(_testShowId));

      // assert
      expect(_res, Left(NoConnectionFailure()));
    },
  );

  test(
    'should return ServerFailure when fetching goes wrong',
    () async {
      // arrange
      when(_mockShowsRepository.fetchShow(_testShowId))
          .thenThrow(ServerException());
      // act
      final _res = await _loadShowUsecaseImpl.call(ShowParams(_testShowId));

      // assert
      expect(_res, Left(ServerFailure()));
    },
  );
}
