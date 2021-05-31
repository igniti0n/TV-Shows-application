import 'dart:developer';

import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/core/usecases/usecase.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/functions/shows/domain/repositories/shows_repository.dart';

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
      log(err.toString());
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
