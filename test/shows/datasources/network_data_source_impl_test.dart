//@dart = 2.9

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/constants/networking.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/network_client.dart';
import 'package:tw_shows/functions/shows/data/datasources/network_data_source.dart';

import '../../fixtures_parser.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

class MockDio extends Mock implements Dio {}

void main() {
  MockNetworkClient _mockNetworkClient;
  MockDio _mockDio;
  NetworkShowsDataSourceImpl _networkShowsDataSourceImpl;

  setUp(() {
    _mockDio = MockDio();
    _mockNetworkClient = MockNetworkClient();
    _networkShowsDataSourceImpl =
        NetworkShowsDataSourceImpl(_mockNetworkClient);
  });
  final Map<String, dynamic> _testResponseData =
      jsonDecode(readFile('all_shows'));

  final Map<String, dynamic> _testResponseDataSingleShow =
      jsonDecode(readFile('single_show'));
  final String _testShowId = 'test_id';

  final Response _testResponseFail = Response(
    data: {},
    requestOptions: RequestOptions(path: 'testPath'),
    statusCode: 400,
  );

  group('fetching all shows', () {
    final Response _testResponse = Response(
      data: _testResponseData,
      requestOptions: RequestOptions(path: 'testPath'),
      statusCode: 200,
    );
    void _setUpAllShows() {
      when(_mockNetworkClient.client).thenReturn(_mockDio);
      when(_mockDio.get(
        ADDR_BASE + 'shows',
      )).thenAnswer((_) async => _testResponse);
    }

    test(
      'should call get request from network client dio',
      () async {
        // arrange

        _setUpAllShows();
        // act
        await _networkShowsDataSourceImpl.fetchAllShows();
        // assert
        verify(_mockDio.get(ADDR_BASE + 'shows')).called(1);
      },
    );

    test(
      'should return correct data map when all goes well',
      () async {
        // arrange

        _setUpAllShows();
        // act
        final _res = await _networkShowsDataSourceImpl.fetchAllShows();
        // assert
        expect(_res, _testResponseData);
      },
    );

    test(
      'should should throw ServerException when reposnse code is not 201',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.get(ADDR_BASE + 'shows'))
            .thenAnswer((_) async => _testResponseFail);

        // act
        final _call = _networkShowsDataSourceImpl.fetchAllShows();

        // assert
        expect(_call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('fetching single show', () {
    final Response _testResponseSingleShow = Response(
        data: _testResponseDataSingleShow,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'testPath'));

    void _setUpSingleShow() {
      when(_mockNetworkClient.client).thenReturn(_mockDio);
      when(_mockDio.get(ADDR_BASE + 'shows/$_testShowId'))
          .thenAnswer((_) async => _testResponseSingleShow);
    }

    test(
      'should call get request from network client dio',
      () async {
        // arrange

        _setUpSingleShow(); // act
        await _networkShowsDataSourceImpl.fetchShow(_testShowId);
        // assert
        verify(_mockDio.get(ADDR_BASE + 'shows/$_testShowId')).called(1);
      },
    );

    test(
      'should should throw ServerException when reposnse code is not 201',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.get(ADDR_BASE + 'shows/$_testShowId'))
            .thenAnswer((_) async => _testResponseFail);

        // act
        final _call = _networkShowsDataSourceImpl.fetchShow(_testShowId);

        // assert
        expect(_call, throwsA(isA<ServerException>()));
      },
    );
  });
}
