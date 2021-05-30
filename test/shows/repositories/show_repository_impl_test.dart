//@dart = 2.9

import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/connection_checker.dart';
import 'package:tw_shows/functions/shows/data/datasources/network_data_source.dart';
import 'package:tw_shows/functions/shows/data/enteties/show_model.dart';
import 'package:tw_shows/functions/shows/data/repositories/shows_repository_impl.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';

import '../../fixtures_parser.dart';

class MockConnectionChecker extends Mock implements ConnectionChecker {}

class MockNetworkShowsDataSource extends Mock
    implements NetworkShowsDataSource {}

void main() {
  MockConnectionChecker _mockConnectionChecker;
  MockNetworkShowsDataSource _mockNetworkShowsDataSource;

  ShowsRepositoryImpl _showsRepositoryImpl;

  setUp(() {
    _mockConnectionChecker = MockConnectionChecker();
    _mockNetworkShowsDataSource = MockNetworkShowsDataSource();
    _showsRepositoryImpl = ShowsRepositoryImpl(
        _mockConnectionChecker, _mockNetworkShowsDataSource);
  });

  final Map<String, dynamic> _testResponseData =
      jsonDecode(readFile('all_shows'));

  final Map<String, dynamic> _testResponseDataSingleShow =
      jsonDecode(readFile('single_show'));

  final String _testShowId = 'test_id';

  final List<Show> _testReturnShowList =
      (_testResponseData['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((e) => ShowModel.fromJson(e))
          .toList();

  final Show _testReturnShow =
      ShowModel.fromJson((_testResponseDataSingleShow['data']));

  _setUpConnection(bool isConnected) {
    when(_mockConnectionChecker.hasConnection)
        .thenAnswer((_) async => isConnected);
  }

  _setUpDatasourceSuccessAllShows() {
    when(_mockNetworkShowsDataSource.fetchAllShows())
        .thenAnswer((_) async => _testResponseData);
  }

  _setUpDatasourceFailAllShows() {
    when(_mockNetworkShowsDataSource.fetchAllShows())
        .thenThrow(ServerException());
  }

  _setUpDatasourceSuccessSingleShow() {
    when(_mockNetworkShowsDataSource.fetchShow(_testShowId))
        .thenAnswer((_) async => _testResponseDataSingleShow);
  }

  _setUpDatasourceFailSingleShow() {
    when(_mockNetworkShowsDataSource.fetchShow(_testShowId))
        .thenThrow(ServerException());
  }

  group('fetching all shows', () {
    test(
      'should check if there is connection',
      () async {
        // arrange
        _setUpConnection(true);
        _setUpDatasourceSuccessAllShows();
        // act
        await _showsRepositoryImpl.fetchAllShows();
        // assert
        verify(_mockConnectionChecker.hasConnection).called(1);
      },
    );

    test(
      'if no connection throw NoConnectionException',
      () async {
        // arrange
        _setUpConnection(false);

        // act
        final res = _showsRepositoryImpl.fetchAllShows();
        // assert
        expect(res, throwsA(isA<NoConnectionException>()));
      },
    );

    test(
      'should call shows datasource to fetch all shows',
      () async {
        // arrange
        _setUpConnection(true);
        _setUpDatasourceSuccessAllShows();
        // act
        await _showsRepositoryImpl.fetchAllShows();
        // assert
        verify(_mockNetworkShowsDataSource.fetchAllShows()).called(1);
      },
    );

    test(
      'should return list of shows from the recieved data from datasource when success',
      () async {
        // arrange
        _setUpConnection(true);
        _setUpDatasourceSuccessAllShows();
        // act
        final _res = await _showsRepositoryImpl.fetchAllShows();
        // assert
        expect(_res, _testReturnShowList);
      },
    );
  });

  group('fetching single show', () {
    test(
      'should check if there is connection',
      () async {
        // arrange
        _setUpConnection(true);
        _setUpDatasourceSuccessSingleShow();
        // act
        await _showsRepositoryImpl.fetchShow(_testShowId);
        // assert
        verify(_mockConnectionChecker.hasConnection).called(1);
      },
    );

    test(
      'if no connection throw NoConnectionException',
      () async {
        // arrange
        _setUpConnection(false);
        // act
        final res = _showsRepositoryImpl.fetchShow(_testShowId);

        // assert
        expect(res, throwsA(isA<NoConnectionException>()));
      },
    );

    test(
      'should call fetchign single show from NetworkShowDataSource',
      () async {
        // arrange
        _setUpDatasourceSuccessSingleShow();
        _setUpConnection(true);
        // act
        await _showsRepositoryImpl.fetchShow(_testShowId);
        // assert
        verify(_mockNetworkShowsDataSource.fetchShow(_testShowId)).called(1);
      },
    );

    test(
      'should return correct Show when all goes well',
      () async {
        // arrange
        _setUpDatasourceSuccessSingleShow();
        _setUpConnection(true);
        // act
        final _res = await _showsRepositoryImpl.fetchShow(_testShowId);
        // assert
        expect(_res, _testReturnShow);
      },
    );
  });
}
