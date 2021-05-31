import 'dart:developer';

import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/core/usecases/usecase.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/domain/repositories/episodes_repository.dart';

class LoadShowEpisodesUsecase extends Usecase<List<Episode>, EpisodesParams> {
  final EpisodesRepository _episodesRepository;

  LoadShowEpisodesUsecase(this._episodesRepository);
  @override
  Future<Either<Failure, List<Episode>>> call(EpisodesParams params) async {
    try {
      final _episodes =
          await _episodesRepository.fetchShowEpisodes(params.showId);
      return Right(_episodes);
    } on NoConnectionException catch (_) {
      return Left(NoConnectionFailure());
    } catch (err) {
      log(err.toString());
      return Left(ServerFailure());
    }
  }
}

class EpisodesParams extends Params {
  final String showId;

  EpisodesParams(this.showId);

  @override
  List<Object?> get props => [showId];
}
