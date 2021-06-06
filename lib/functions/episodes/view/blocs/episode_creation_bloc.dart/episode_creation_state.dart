part of 'episode_creation_bloc.dart';

abstract class EpisodeCreationState extends Equatable {
  const EpisodeCreationState();
}

class EpisodeCreationInitial extends EpisodeCreationState {
  @override
  List<Object> get props => [];
}

class EpisodeCreationLoading extends EpisodeCreationState {
  @override
  List<Object> get props => [];
}

class EpisodeCreationSuccess extends EpisodeCreationState {
  @override
  List<Object> get props => [];
}

class EpisodeCreationFail extends EpisodeCreationState {
  final String message;

  EpisodeCreationFail(this.message);

  @override
  List<Object> get props => [message];
}
