import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../../../episodes/domain/models/episode.dart';
import '../../../../episodes/view/blocs/episodes_bloc/episodes_bloc.dart';
import 'episode_tile.dart';

class EpisodesList extends StatelessWidget {
  final String showId;
  const EpisodesList(
    this.showId, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;

    return BlocBuilder<EpisodesBloc, EpisodesState>(
      builder: (context, episodesState) {
        if (episodesState is EpisodesLoaded) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, index) => EpisodeTile(
                currentEpisode: _copyEpisodeWithShowId(
                    episodesState.episodes[index], showId),
                deviceSize: _deviceSize,
              ),
              childCount: episodesState.episodes.length,
            ),
          );
        } else if (episodesState is EpisodesError) {
          return _buildError(episodesState, context);
        }
        return _buildLoading();
      },
    );
  }

  Episode _copyEpisodeWithShowId(Episode episode, String showId) {
    return Episode(
      description: episode.description,
      imageUrl: episode.imageUrl,
      title: episode.title,
      seasonNumber: episode.seasonNumber,
      episodeNumber: episode.episodeNumber,
      id: episode.id,
      showId: showId,
    );
  }

  SliverToBoxAdapter _buildLoading() {
    return SliverToBoxAdapter(
      child: Center(
        child: PlatformCircularProgressIndicator(),
      ),
    );
  }

  SliverToBoxAdapter _buildError(
      EpisodesError episodesState, BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: PlatformText(
            episodesState.message,
            style: platformThemeData(
              context,
              material: (data) => data.textTheme.bodyText1,
              cupertino: (data) => data.textTheme.textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
