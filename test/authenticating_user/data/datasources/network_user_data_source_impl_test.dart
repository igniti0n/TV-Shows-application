//@dart=2.9

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/constants/networking.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/network_client.dart';
import 'package:tw_shows/functions/authenticating_user/data/datasources/network_user_data_source.dart';
import 'package:tw_shows/functions/authenticating_user/data/entities/user_model.dart';
import 'package:tw_shows/functions/authenticating_user/domain/models/user.dart';
import 'package:tw_shows/functions/comments/data/enteties/comment_model.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

class MockDio extends Mock implements Dio {}

void main() {
  MockNetworkClient _mockNetworkClient;
  MockDio _mockDio;
  NetworkUserDataSourceImpl _networkUserDataSourceImpl;

  setUp(() {
    _mockDio = MockDio();
    _mockNetworkClient = MockNetworkClient();
    _networkUserDataSourceImpl = NetworkUserDataSourceImpl(_mockNetworkClient);
  });

  final UserModel _testUserModel = UserModel('email', 'password');
  final User _testUser = _testUserModel;

  final Response _testResponseFail = Response(
    data: {},
    statusCode: 400,
    requestOptions: RequestOptions(path: 'testPath'),
  );

  final Response _testResponse = Response(
    data: {},
    statusCode: 200,
    requestOptions: RequestOptions(path: 'testPath'),
  );

  group('signing in', () {
    test(
      'should call .post with right addres on network client dio',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.post(
          ADDR_BASE + 'users/sessions',
          data: _testUserModel.toJson(),
        )).thenAnswer((_) async => _testResponse);
        // act
        await _networkUserDataSourceImpl.signIn(_testUserModel);

        // assert
        verify(_mockDio.post(
          ADDR_BASE + 'users/sessions',
          data: _testUserModel.toJson(),
        )).called(1);
        verifyNoMoreInteractions(_mockDio);
      },
    );

    test(
      'should throw ServerException when there is bad response',
      () async {
        // arrange
        when(_mockNetworkClient.client).thenReturn(_mockDio);
        when(_mockDio.post(
          ADDR_BASE + 'users/sessions',
          data: _testUserModel.toJson(),
        )).thenAnswer((_) async => _testResponseFail);
        // act
        final _call = _networkUserDataSourceImpl.signIn(_testUserModel);

        // assert
        expect(_call, throwsA(isA<ServerException>()));
      },
    );
  });
}
