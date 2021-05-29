import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/core/usecases/usecase.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/domain/usecases/load_shows_usecase.dart';

class LoadShowsUsecaseImpl extends LoadShowsUsecase{
  @override
  Future<Either<Failure, List<Show>>> call(NoParams noParams) {
    // TODO: implement call
    throw UnimplementedError();
  }
}