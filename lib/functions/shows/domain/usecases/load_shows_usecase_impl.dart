import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/core/usecases/usecase.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/domain/repositories/shows_repository.dart';

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
