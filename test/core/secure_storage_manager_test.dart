//@dart = 2.9

import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tw_shows/core/storage/secure_storage_manager.dart';
import 'package:tw_shows/functions/authenticating_user/data/entities/user_model.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  MockSecureStorage _mockSecureStorage;
  SecureStorageManagerImpl _secureStorageManagerImpl;

  setUp(() {
    _mockSecureStorage = MockSecureStorage();
    _secureStorageManagerImpl = SecureStorageManagerImpl(_mockSecureStorage);
  });

  final UserModel _testUserModel = UserModel('email', 'password');
  final String _testSavedUser = jsonEncode(_testUserModel.toJson());

  final Map<String, dynamic> _testEmptyMap = {
    'email': '',
    'password': '',
  };

  group('loading rememberd user', () {
    test(
      'should call .read with USER_STORAGE_KEY',
      () async {
        // arrange

        // act
        await _secureStorageManagerImpl.loadRememberdUser();
        // assert
        verify(_mockSecureStorage.read(key: USER_STORAGE_KEY)).called(1);
        verifyNoMoreInteractions(_mockSecureStorage);
      },
    );

    test(
      'should return correct map when there is something saved',
      () async {
        // arrange
        when(_mockSecureStorage.read(key: USER_STORAGE_KEY))
            .thenAnswer((_) async => _testSavedUser);
        // act
        final _res = await _secureStorageManagerImpl.loadRememberdUser();
        // assert
        expect(_res, _testUserModel.toJson());
      },
    );

    test(
      'should return map with empty user data when there is something saved',
      () async {
        // arrange
        when(_mockSecureStorage.read(key: USER_STORAGE_KEY))
            .thenAnswer((_) async => null);
        // act
        final _res = await _secureStorageManagerImpl.loadRememberdUser();
        // assert
        expect(_res, _testEmptyMap);
      },
    );
  });

  group('saving rememberd user', () {
    test(
      'should call .write with USER_STORAGE_KEY and correct user data',
      () async {
        // arrange

        // act
        await _secureStorageManagerImpl.saveRememberdUser(_testUserModel);
        // assert
        verify(_mockSecureStorage.write(
                key: USER_STORAGE_KEY, value: _testSavedUser))
            .called(1);
        verifyNoMoreInteractions(_mockSecureStorage);
      },
    );
  });
}
