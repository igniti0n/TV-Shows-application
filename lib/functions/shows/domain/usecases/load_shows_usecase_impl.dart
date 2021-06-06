import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../models/show.dart';
import '../repositories/shows_repository.dart';

class LoadShowsUsecase extends Usecase<List<Show>, NoParams> {
  final ShowsRepository _showsRepository;

  LoadShowsUsecase(this._showsRepository);

  @override
  Future<Either<Failure, List<Show>>> call(NoParams noParams) async {
    try {
      final _res = await _showsRepository.fetchAllShows();
      return Right(_res);
    } on NoConnectionException catch (_) {
      return Left(NoConnectionFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
