part of 'episode_form_bloc.dart';

abstract class EpisodeFormEvent extends Equatable {
  const EpisodeFormEvent();
}

class EpisodeCreationScreenStarted extends EpisodeFormEvent {
  final String showId;

  EpisodeCreationScreenStarted(this.showId);
  @override
  List<Object> get props => [showId];
}

class EpisodeImageChanged extends EpisodeFormEvent {
  final String filePath;

  EpisodeImageChanged(this.filePath);
  @override
  List<Object> get props => [filePath];
}

class EpisodeTitleChanged extends EpisodeFormEvent {
  final String title;

  EpisodeTitleChanged(this.title);
  @override
  List<Object> get props => [title];
}

class EpisodeDescriptionChanged extends EpisodeFormEvent {
  final String description;

  EpisodeDescriptionChanged(this.description);
  @override
  List<Object> get props => [description];
}

class EpisodeNumberChanged extends EpisodeFormEvent {
  final String episodeNumber;

  EpisodeNumberChanged(this.episodeNumber);
  @override
  List<Object> get props => [episodeNumber];
}

class EpisodeClear extends EpisodeFormEvent {
  EpisodeClear();
  @override
  List<Object> get props => [];
}
