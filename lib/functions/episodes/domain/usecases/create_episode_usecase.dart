import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/core/usecases/usecase.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/domain/repositories/episodes_repository.dart';

class CreateEpisodeUsecase extends Usecase<void, EpisodeCreateParams> {
  final EpisodesRepository _episodesRepository;

  CreateEpisodeUsecase(this._episodesRepository);
  @override
  Future<Either<Failure, void>> call(EpisodeCreateParams params) async {
    try {
      await _episodesRepository.createNewEpisode(params.episode);
      return Right(NoParams());
    } on NoConnectionException catch (_) {
      return Left(NoConnectionFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}

class EpisodeCreateParams extends Params {
  final Episode episode;

  EpisodeCreateParams(this.episode);

  @override
  List<Object?> get props => [episode];
}
