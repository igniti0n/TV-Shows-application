part of 'episode_form_bloc.dart';

abstract class EpisodeFormState extends Equatable {
  final Episode episode;

  const EpisodeFormState(this.episode);

  @override
  List<Object> get props => [episode];
}

class EpisodeFormInitial extends EpisodeFormState {
  EpisodeFormInitial(Episode? episode)
      : super(
          episode ??
              Episode(
                  description: '',
                  imageUrl: '',
                  title: '',
                  seasonNumber: '',
                  episodeNumber: '',
                  id: '',
                  showId: ''),
        );
}

class EpisodeFormChanged extends EpisodeFormState {
  EpisodeFormChanged(Episode episode) : super(episode);
}
