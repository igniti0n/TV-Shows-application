import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../models/episode.dart';
import '../repositories/episodes_repository.dart';

class LoadEpisodeUsecase extends Usecase<Episode, EpisodeParams> {
  final EpisodesRepository _episodesRepository;

  LoadEpisodeUsecase(this._episodesRepository);
  @override
  Future<Either<Failure, Episode>> call(EpisodeParams params) async {
    try {
      final _episode = await _episodesRepository.fetchEpisode(params.episodeId);
      return Right(_episode);
    } on NoConnectionException catch (_) {
      return Left(NoConnectionFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}

class EpisodeParams extends Params {
  final String episodeId;

  EpisodeParams(this.episodeId);

  @override
  List<Object?> get props => [episodeId];
}
