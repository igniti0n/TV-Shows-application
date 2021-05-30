//@dart=2.9
import 'package:bloc_test/bloc_test.dart' as bl;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tw_shows/functions/authetication_checker/domain/models/auth_credentials.dart';
import 'package:tw_shows/functions/authetication_checker/domain/usecases/load_rememberd_user_usecase.dart';
import 'package:tw_shows/functions/authetication_checker/view/auth_form_bloc/auth_form_bloc.dart';

class MockLoadRememberdUserUsecase extends Mock
    implements LoadRememberdUserUsecase {}

void main() {
  MockLoadRememberdUserUsecase _mockLoadRememberdUserUsecase;

  setUp(() {
    _mockLoadRememberdUserUsecase = MockLoadRememberdUserUsecase();
  });

  final _testEmail = 'test';
  final _testPassword = 'testPass';
  final _testConfirmPassowrd = 'testConfrimPass';

  final _testCredentials = AuthCredentials(
    emailCredential: EmailCredential.initial(),
    passwordCredential: PasswordCredential.initial(),
  );

  final _testEmailCred = EmailCredential(_testEmail);
  final _testPassCres = PasswordCredential(_testPassword);

  bl.blocTest(
    'should emit AuthFormChanged with correct credentials when email changed',
    build: () => AuthFormBloc(_mockLoadRememberdUserUsecase),
    wait: Duration(milliseconds: 120),
    act: (bloc) => bloc.add(EmailChanged(_testEmail)),
    expect: () => [
      AuthFormChanged(AuthCredentials(
        emailCredential: _testEmailCred,
        passwordCredential: PasswordCredential.initial(),
      ))
    ],
  );

  bl.blocTest(
    'should emit AuthFormChanged with correct credentials when password cofnirmed changed',
    build: () => AuthFormBloc(_mockLoadRememberdUserUsecase),
    act: (bloc) => bloc.add(PasswordChanged(_testPassword)),
    wait: Duration(milliseconds: 120),
    expect: () => [
      AuthFormChanged(AuthCredentials(
        emailCredential: EmailCredential.initial(),
        passwordCredential: _testPassCres,
      ))
    ],
  );

  bl.blocTest(
    'should emit AuthFormChanged with correct credentials when password changed',
    build: () => AuthFormBloc(_mockLoadRememberdUserUsecase),
    wait: Duration(milliseconds: 120),
    act: (bloc) =>
        bloc.add(PasswordConfirmChanged(_testPassword, _testConfirmPassowrd)),
    expect: () => [
      AuthFormChanged(AuthCredentials(
        emailCredential: EmailCredential.initial(),
        passwordCredential: PasswordCredential.initial(),
      ))
    ],
  );
}
