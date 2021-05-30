part of 'episodes_bloc.dart';

abstract class EpisodesEvent extends Equatable {
  const EpisodesEvent();
}

class FetchShowEpisodes extends EpisodesEvent {
  final String showId;

  FetchShowEpisodes(this.showId);

  @override
  List<Object> get props => [showId];
}
