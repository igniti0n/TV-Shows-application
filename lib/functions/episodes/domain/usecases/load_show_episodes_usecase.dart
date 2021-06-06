import 'dart:developer';

import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../models/episode.dart';
import '../repositories/episodes_repository.dart';

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
