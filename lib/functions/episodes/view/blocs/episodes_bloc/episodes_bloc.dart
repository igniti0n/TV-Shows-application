import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/view/usecases/load_show_episodes_usecase.dart';

part 'episodes_event.dart';
part 'episodes_state.dart';

class EpisodesBloc extends Bloc<EpisodesEvent, EpisodesState> {
  final LoadShowEpisodesUsecase _loadShowEpisodesUsecase;
  EpisodesBloc(this._loadShowEpisodesUsecase) : super(EpisodesInitial());

  @override
  Stream<EpisodesState> mapEventToState(
    EpisodesEvent event,
  ) async* {
    yield EpisodesLoading();
    if (event is FetchShowEpisodes) {
      final _responseEither =
          await _loadShowEpisodesUsecase(EpisodesParams(event.showId));
      yield _responseEither.fold(
        (Failure failure) => EpisodesError(failure.message),
        (List<Episode> episodes) => EpisodesLoaded(episodes),
      );
    }
  }
}
