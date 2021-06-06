import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class SignOutUserUsecase extends Usecase<void, NoParams> {
  final UserRepository _userRepository;

  SignOutUserUsecase(this._userRepository);
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await _userRepository.signOut();
      return Right(NoParams());
    } on NoConnectionException catch (_) {
      return Left(NoConnectionFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
