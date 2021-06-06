import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/create_episode_usecase.dart';

part 'episode_creation_event.dart';
part 'episode_creation_state.dart';

class EpisodeCreationBloc
    extends Bloc<EpisodeCreationEvent, EpisodeCreationState> {
  final CreateEpisodeUsecase _createEpisodeUsecase;
  EpisodeCreationBloc(this._createEpisodeUsecase)
      : super(EpisodeCreationInitial());

  @override
  Stream<EpisodeCreationState> mapEventToState(
    EpisodeCreationEvent event,
  ) async* {
    if (event is CreateEpisode) {
      yield EpisodeCreationLoading();
      final _either =
          await _createEpisodeUsecase(EpisodeCreateParams(event.episode));

      yield _either.fold(
        (Failure failure) => EpisodeCreationFail(failure.message),
        (nothing) => EpisodeCreationSuccess(),
      );
    }
  }
}
