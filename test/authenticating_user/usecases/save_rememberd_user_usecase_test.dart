//@dart=2.9

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/functions/authenticating_user/domain/models/user.dart';
import 'package:tw_shows/functions/authenticating_user/domain/repositories/user_repository.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/save_rememberd_user_usecase.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/sign_in_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository _mockUserRepository;
  SaveRememberdUserUsecase _saveRememberdUserUsecase;

  setUp(() {
    _mockUserRepository = MockUserRepository();
    _saveRememberdUserUsecase = SaveRememberdUserUsecase(_mockUserRepository);
  });

  final User _testUser = User('email', 'password');

  test(
    'should call .saveRememberdUser from UserRepository',
    () async {
      // arrange
      when(_mockUserRepository.saveRememberdUser(_testUser))
          .thenAnswer((_) async => NoParams());
      // act
      await _saveRememberdUserUsecase(SignInParams(_testUser));
      // assert
      verify(_mockUserRepository.saveRememberdUser(_testUser)).called(1);
      verifyNoMoreInteractions(_mockUserRepository);
    },
  );

  test(
    'should return LocalStorageFailure when LocalStorageException occurres',
    () async {
      // arrange
      when(_mockUserRepository.saveRememberdUser(_testUser))
          .thenThrow(LocalStorageException());
      // act
      final _response =
          await _saveRememberdUserUsecase(SignInParams(_testUser));
      // assert
      expect(_response, Left(LocalStorageFailure()));
    },
  );
}
