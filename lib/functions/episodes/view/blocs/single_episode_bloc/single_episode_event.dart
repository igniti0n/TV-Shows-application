part of 'single_episode_bloc.dart';

abstract class SingleEpisodeEvent extends Equatable {
  const SingleEpisodeEvent();
}

class FetchEpisode extends SingleEpisodeEvent {
  final String episodeId;

  FetchEpisode(this.episodeId);
  @override
  List<Object> get props => [episodeId];
}
