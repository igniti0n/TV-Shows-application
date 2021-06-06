//@dart=2.9

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/connection_checker.dart';
import 'package:tw_shows/core/storage/secure_storage_manager.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/functions/authenticating_user/data/datasources/network_user_data_source.dart';
import 'package:tw_shows/functions/authenticating_user/data/entities/user_model.dart';
import 'package:tw_shows/functions/authenticating_user/data/repositories/user_repository_impl.dart';
import 'package:tw_shows/functions/authenticating_user/domain/models/user.dart';

class MockNetworkUserDataSource extends Mock implements NetworkUserDataSource {}

class MockSecureStorageManager extends Mock implements SecureStorageManager {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

void main() {
  MockNetworkUserDataSource _mockNetworkUserDataSource;
  MockSecureStorageManager _mockSecureStorageManager;
  MockConnectionChecker _mockConnectionChecker;
  UserRepositoryImpl _userRepositoryImpl;

  setUp(() {
    _mockNetworkUserDataSource = MockNetworkUserDataSource();
    _mockSecureStorageManager = MockSecureStorageManager();
    _mockConnectionChecker = MockConnectionChecker();
    _userRepositoryImpl = UserRepositoryImpl(
      _mockNetworkUserDataSource,
      _mockSecureStorageManager,
      _mockConnectionChecker,
    );
  });

  final UserModel _testUserModel = UserModel('email', 'password');
  final User _testUser = _testUserModel;

  group('authenticatin user', () {
    test(
      'should check if there is Internet connection',
      () async {
        // arrange
        when(_mockConnectionChecker.hasConnection)
            .thenAnswer((_) async => true);

        // act
        await _userRepositoryImpl
            .authenticateUserWithEmailAndPassword(_testUser);

        // assert
        verify(_mockConnectionChecker.hasConnection).called(1);

        verifyNoMoreInteractions(_mockConnectionChecker);
      },
    );

    test(
      'should throw NoConnectionException when there is no Internet connection',
      () async {
        // arrange
        when(_mockConnectionChecker.hasConnection)
            .thenAnswer((_) async => false);

        // act
        final _call =
            _userRepositoryImpl.authenticateUserWithEmailAndPassword(_testUser);

        // assert
        expect(_call, throwsA(isA<NoConnectionException>()));
      },
    );

    test(
      'should call .signIn with right credentials on NetworkDataSource',
      () async {
        // arrange
        when(_mockConnectionChecker.hasConnection)
            .thenAnswer((_) async => true);

        when(_mockNetworkUserDataSource.signIn(_testUserModel))
            .thenAnswer((_) async => NoParams());
        // act
        await _userRepositoryImpl
            .authenticateUserWithEmailAndPassword(_testUser);

        // assert
        verify(_mockNetworkUserDataSource.signIn(_testUserModel)).called(1);
        verifyNoMoreInteractions(_mockNetworkUserDataSource);
        verifyZeroInteractions(_mockSecureStorageManager);
      },
    );
  });

  group('signing out', () {
    test(
      'should call .signOut',
      () async {
        // arrange
        when(_mockNetworkUserDataSource.signOut())
            .thenAnswer((_) async => NoParams());
        // act
        await _userRepositoryImpl.signOut();

        // assert
        verify(_mockNetworkUserDataSource.signOut()).called(1);
        verifyNoMoreInteractions(_mockNetworkUserDataSource);
        verifyZeroInteractions(_mockSecureStorageManager);
      },
    );
  });

  group('loading rememberd user', () {
    _setUpLoadingUser() {
      when(_mockSecureStorageManager.loadRememberdUser())
          .thenAnswer((_) async => _testUserModel.toJson());
    }

    test(
      'should call .loadRememberdUser on SecureStorageManager',
      () async {
        // arrange
        _setUpLoadingUser();
        // act
        await _userRepositoryImpl.loadRememberdUser();
        // assert
        verify(_mockSecureStorageManager.loadRememberdUser()).called(1);
        verifyNoMoreInteractions(_mockSecureStorageManager);
        verifyZeroInteractions(_mockNetworkUserDataSource);
      },
    );

    test(
      'should return correct data when loading success',
      () async {
        // arrange
        _setUpLoadingUser();
        // act
        final _res = await _userRepositoryImpl.loadRememberdUser();
        // assert
        expect(_res, _testUser);
      },
    );
  });

  group('saving rememberd user', () {
    test(
      'should call .saveRememberdUser on SecureStorageManager',
      () async {
        // arrange

        // act
        await _userRepositoryImpl.saveRememberdUser(_testUser);

        // assert
        verify(_mockSecureStorageManager.saveRememberdUser(_testUserModel))
            .called(1);
        verifyNoMoreInteractions(_mockSecureStorageManager);
        verifyZeroInteractions(_mockNetworkUserDataSource);
      },
    );
  });
}
