import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episode_image/episode_image_bloc.dart';

part 'episode_form_event.dart';
part 'episode_form_state.dart';

class EpisodeFormBloc extends Bloc<EpisodeFormEvent, EpisodeFormState> {
  EpisodeFormBloc() : super(EpisodeFormInitial(null));

  @override
  Stream<EpisodeFormState> mapEventToState(
    EpisodeFormEvent event,
  ) async* {
    if (event is EpisodeTitleChanged) {
      yield EpisodeFormChanged(state.episode.copyWith(title: event.title));
    } else if (event is EpisodeDescriptionChanged) {
      yield EpisodeFormChanged(
          state.episode.copyWith(description: event.description));
    } else if (event is EpisodeImageChanged) {
      yield EpisodeFormChanged(
          state.episode.copyWith(imageUrl: event.filePath));
    } else if (event is EpisodeNumberChanged) {
      yield _yieldStateForEpisodeNumber(event);
    } else if (event is EpisodeCreationScreenStarted) {
      yield EpisodeFormChanged(
        state.episode.copyWith(
          showId: event.showId,
        ),
      );
    } else if (event is EpisodeClear) {
      yield EpisodeFormChanged(
        state.episode.copyWith(
          showId: '',
          description: '',
          episodeNumber: '',
          imageUrl: '',
          seasonNumber: '',
          title: '',
        ),
      );
    }
  }

  EpisodeFormState _yieldStateForEpisodeNumber(EpisodeNumberChanged event) {
    final _numberParts = event.episodeNumber.split('&');
    final String _seasonNumber = _numberParts.length > 0 ? _numberParts[0] : '';
    final String _episodeNumber =
        _numberParts.length > 1 ? _numberParts[1] : '';
    return EpisodeFormChanged(
      state.episode.copyWith(
        seasonNumber: _seasonNumber,
        episodeNumber: _episodeNumber,
      ),
    );
  }
}
