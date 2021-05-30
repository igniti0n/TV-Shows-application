import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/core/usecases/usecase.dart';
import 'package:tw_shows/functions/authenticating_user/domain/models/user.dart';
import 'package:tw_shows/functions/authenticating_user/domain/repositories/user_repository.dart';

class SignInUserUsecase extends Usecase<void, SignInParams> {
  final UserRepository _userRepository;

  SignInUserUsecase(this._userRepository);

  @override
  Future<Either<Failure, void>> call(SignInParams params) async {
    try {
      await _userRepository.authenticateUserWithEmailAndPassword(params.user);
      return Right(NoParams());
    } on NoConnectionException catch (_) {
      return Left(NoConnectionFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}

class SignInParams extends Params {
  final User user;

  SignInParams(this.user);

  @override
  List<Object?> get props => [];
}
