//@dart=2.9
import 'package:bloc_test/bloc_test.dart' as bl;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tw_shows/core/constants/error_messages.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/functions/authenticating_user/domain/models/user.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/save_rememberd_user_usecase.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/sign_in_user_usecase.dart';
import 'package:tw_shows/functions/authenticating_user/domain/usecases/sign_out_user_usecase.dart';
import 'package:tw_shows/functions/authenticating_user/view/auth_bloc/auth_bloc_bloc.dart';
import 'package:tw_shows/functions/authetication_checker/domain/models/auth_credentials.dart';
import 'package:tw_shows/functions/authetication_checker/domain/usecases/load_rememberd_user_usecase.dart';
import 'package:tw_shows/functions/authetication_checker/view/auth_form_bloc/auth_form_bloc.dart';

class MockSignInUserUsecase extends Mock implements SignInUserUsecase {}

class MockSignOutUserUsecase extends Mock implements SignOutUserUsecase {}

class MockSaveRememberdUserUsecase extends Mock
    implements SaveRememberdUserUsecase {}

void main() {
  MockSignInUserUsecase _mockSignInUserUsecase;
  MockSignOutUserUsecase _mockSignOutUserUsecase;

  MockSaveRememberdUserUsecase _mockSaveRememberdUserUsecase;

  setUp(() {
    _mockSignInUserUsecase = MockSignInUserUsecase();
    _mockSignOutUserUsecase = MockSignOutUserUsecase();

    _mockSaveRememberdUserUsecase = MockSaveRememberdUserUsecase();
  });

  final _testEmail = 'test';
  final _testPassword = 'testPass';

  final User _testUser = User(_testEmail, _testPassword);

  bl.blocTest(
    'should emit [AuthLoadnig(),AuthSuccessful()]on LogIn event when auth is success, and save user when rememberd',
    build: () {
      when(_mockSignInUserUsecase(SignInParams(_testUser)))
          .thenAnswer((_) async => Right(NoParams()));
      when(_mockSaveRememberdUserUsecase(SignInParams(_testUser)))
          .thenAnswer((_) async => Right(NoParams()));
      return AuthBloc(
        _mockSignInUserUsecase,
        _mockSignOutUserUsecase,
        _mockSaveRememberdUserUsecase,
      );
    },
    act: (bloc) => bloc.add(LogIn(_testEmail, _testPassword, true)),
    expect: () => [
      AuthLoading(),
      AuthSuccesfull(),
    ],
    verify: (_) =>
        verify(_mockSaveRememberdUserUsecase(SignInParams(_testUser)))
            .called(1),
  );

  bl.blocTest(
    'should emit [AuthLoadnig(),AuthSuccessful()] on LogIn event when auth is success, and NOT save user when not rememberd',
    build: () {
      when(_mockSignInUserUsecase(SignInParams(_testUser)))
          .thenAnswer((_) async => Right(NoParams()));
      when(_mockSaveRememberdUserUsecase(SignInParams(_testUser)))
          .thenAnswer((_) async => Right(NoParams()));
      return AuthBloc(
        _mockSignInUserUsecase,
        _mockSignOutUserUsecase,
        _mockSaveRememberdUserUsecase,
      );
    },
    act: (bloc) => bloc.add(LogIn(_testEmail, _testPassword, false)),
    expect: () => [
      AuthLoading(),
      AuthSuccesfull(),
    ],
    verify: (_) =>
        verify(_mockSaveRememberdUserUsecase(SignInParams(User('', '')))),
  );

  bl.blocTest(
    'should emit [AuthLoadnig(),AuthFailed()] with ERR_SERV on LogIn event when auth is failed with ServerException',
    build: () {
      when(_mockSignInUserUsecase(SignInParams(_testUser)))
          .thenAnswer((_) async => Left(ServerFailure()));

      return AuthBloc(
        _mockSignInUserUsecase,
        _mockSignOutUserUsecase,
        _mockSaveRememberdUserUsecase,
      );
    },
    act: (bloc) => bloc.add(LogIn(_testEmail, _testPassword, false)),
    expect: () => [
      AuthLoading(),
      AuthFailed(ERROR_SERVER),
    ],
  );

  bl.blocTest(
    'should emit [AuthLoadnig(),AuthFailed()] with ERR_NO_CONNECTION on LogIn event when auth is failed with NoConnectionFailure',
    build: () {
      when(_mockSignInUserUsecase(SignInParams(_testUser)))
          .thenAnswer((_) async => Left(NoConnectionFailure()));

      return AuthBloc(
        _mockSignInUserUsecase,
        _mockSignOutUserUsecase,
        _mockSaveRememberdUserUsecase,
      );
    },
    act: (bloc) => bloc.add(LogIn(_testEmail, _testPassword, false)),
    expect: () => [
      AuthLoading(),
      AuthFailed(ERROR_NO_CONNECTION),
    ],
  );
}
