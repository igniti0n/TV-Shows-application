import 'package:dartz/dartz.dart';
import '../../../../core/usecases/params.dart';

import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/error/failures/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../models/show.dart';
import '../repositories/shows_repository.dart';

class LoadShowUsecase extends Usecase<Show, ShowParams> {
  final ShowsRepository _showsRepository;

  LoadShowUsecase(this._showsRepository);
  @override
  Future<Either<Failure, Show>> call(ShowParams params) async {
    try {
      final _show = await _showsRepository.fetchShow(params.showId);
      return Right(_show);
    } on NoConnectionException catch (_) {
      return Left(NoConnectionFailure());
    } catch (err) {
      return Left(ServerFailure());
    }
  }
}

class ShowParams extends Params {
  final String showId;

  ShowParams(this.showId);
  @override
  List<Object?> get props => [showId];
}
