//@dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episode_form_bloc/episode_form_bloc.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episode_image/episode_image_bloc.dart';

void main() {
  final String _testImagePath = 'iamge_path';

  final String _testTitle = 'title';

  final String _testDescription = 'desciption';

  final String _testEpisodeNumber = 'S4&E4';

  final _testEpisodeInitial = Episode(
      description: '',
      imageUrl: '',
      title: '',
      seasonNumber: '',
      episodeNumber: '',
      id: '',
      showId: '');

  blocTest(
    'should emit correct episode when EpisodeImageChanged event',
    build: () {
      return EpisodeFormBloc();
    },
    act: (EpisodeFormBloc bloc) =>
        bloc.add(EpisodeImageChanged(_testImagePath)),
    expect: () => [
      EpisodeFormChanged(
        _testEpisodeInitial.copyWith(
          imageUrl: _testImagePath,
        ),
      )
    ],
  );

  blocTest(
    'should emit correct episode when EpisodeTitleChanged event',
    build: () {
      return EpisodeFormBloc();
    },
    act: (EpisodeFormBloc bloc) => bloc.add(EpisodeTitleChanged(_testTitle)),
    expect: () => [
      EpisodeFormChanged(
        _testEpisodeInitial.copyWith(
          title: _testTitle,
        ),
      )
    ],
  );

  blocTest(
    'should emit correct episode when EpisodeDescriptionChanged event',
    build: () {
      return EpisodeFormBloc();
    },
    act: (EpisodeFormBloc bloc) =>
        bloc.add(EpisodeDescriptionChanged(_testDescription)),
    expect: () => [
      EpisodeFormChanged(
        _testEpisodeInitial.copyWith(
          description: _testDescription,
        ),
      )
    ],
  );

  blocTest(
    'should emit correct episode when EpisodeNumberChanged event',
    build: () {
      return EpisodeFormBloc();
    },
    act: (EpisodeFormBloc bloc) =>
        bloc.add(EpisodeNumberChanged(_testEpisodeNumber)),
    expect: () => [
      EpisodeFormChanged(
        _testEpisodeInitial.copyWith(
          seasonNumber: 'S4',
          episodeNumber: 'E4',
        ),
      )
    ],
  );
}
