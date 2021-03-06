import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures/failures.dart';
import '../../../domain/models/episode.dart';
import '../../../domain/usecases/load_episode_usecase.dart';

part 'single_episode_event.dart';
part 'single_episode_state.dart';

class SingleEpisodeBloc extends Bloc<SingleEpisodeEvent, SingleEpisodeState> {
  final LoadEpisodeUsecase _loadEpisodeUsecase;
  SingleEpisodeBloc(this._loadEpisodeUsecase) : super(SingleEpisodeInitial());

  @override
  Stream<SingleEpisodeState> mapEventToState(
    SingleEpisodeEvent event,
  ) async* {
    yield SingleEpisodeLoading();
    if (event is FetchEpisode) {
      final _eitherResponse =
          await _loadEpisodeUsecase(EpisodeParams(event.episodeId));
      yield _yieldSingleEpisodeStateForFetchingShow(_eitherResponse);
    }
  }

  SingleEpisodeState _yieldSingleEpisodeStateForFetchingShow(
      Either<Failure, Episode> _eitherResponse) {
    return _eitherResponse.fold(
        (Failure failure) => SingleEpisodeError(failure.message),
        (Episode episode) => SingleEpisodeLoaded(episode));
  }
}
