part of 'episodes_bloc.dart';

abstract class EpisodesState extends Equatable {
  const EpisodesState();
}

class EpisodesInitial extends EpisodesState {
  @override
  List<Object> get props => [];
}

class EpisodesLoading extends EpisodesState {
  @override
  List<Object?> get props => [];
}

class EpisodesLoaded extends EpisodesState {
  final List<Episode> episodes;

  EpisodesLoaded(this.episodes);
  @override
  List<Object?> get props => [episodes];
}

class EpisodesError extends EpisodesState {
  final String message;

  EpisodesError(this.message);
  @override
  List<Object?> get props => [message];
}
