import '../../../../core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../authenticating_user/domain/models/user.dart';
import '../../../authenticating_user/domain/repositories/user_repository.dart';

class LoadRememberdUserUsecase extends Usecase<User, NoParams> {
  final UserRepository _userRepository;

  LoadRememberdUserUsecase(this._userRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    try {
      final _user = await _userRepository.loadRememberdUser();
      return Right(_user);
    } catch (_) {
      return Left(LocalStorageFailure());
    }
  }
}
