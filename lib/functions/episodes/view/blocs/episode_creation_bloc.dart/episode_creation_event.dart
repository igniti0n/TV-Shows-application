part of 'episode_creation_bloc.dart';

abstract class EpisodeCreationEvent extends Equatable {
  final Episode episode;
  const EpisodeCreationEvent(this.episode);

  @override
  List<Object> get props => [episode];
}

class CreateEpisode extends EpisodeCreationEvent {
  CreateEpisode(Episode episode) : super(episode);
}
