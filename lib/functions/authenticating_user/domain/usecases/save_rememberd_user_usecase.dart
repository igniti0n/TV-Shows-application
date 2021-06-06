import '../../../../core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';
import 'sign_in_user_usecase.dart';

class SaveRememberdUserUsecase extends Usecase<void, SignInParams> {
  final UserRepository _userRepository;

  SaveRememberdUserUsecase(this._userRepository);
  @override
  Future<Either<Failure, void>> call(SignInParams params) async {
    try {
      await _userRepository.saveRememberdUser(params.user);
      return Right(NoParams());
    } catch (_) {
      return Left(LocalStorageFailure());
    }
  }
}
