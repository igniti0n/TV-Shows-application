part of 'single_episode_bloc.dart';

abstract class SingleEpisodeState extends Equatable {
  const SingleEpisodeState();
}

class SingleEpisodeInitial extends SingleEpisodeState {
  @override
  List<Object> get props => [];
}

class SingleEpisodeLoading extends SingleEpisodeState {
  @override
  List<Object> get props => [];
}

class SingleEpisodeLoaded extends SingleEpisodeState {
  final Episode episode;

  SingleEpisodeLoaded(this.episode);
  @override
  List<Object> get props => [episode];
}

class SingleEpisodeError extends SingleEpisodeState {
  final String message;

  SingleEpisodeError(this.message);
  @override
  List<Object> get props => [message];
}
