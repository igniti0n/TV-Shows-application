import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/core/usecases/usecase.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';

abstract class LoadShowsUsecase extends Usecase<List<Show>, NoParams> {
  @override
  Future<Either<Failure, List<Show>>> call(NoParams noParams);
}
