import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_shows/core/constants/colors.dart';
import 'package:tw_shows/core/constants/pages.dart';
import 'package:tw_shows/functions/comments/view/blocs/comments_bloc/comments_bloc.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/shows/view/blocs/single_show_bloc/single_show_bloc.dart';

class EpisodeDetailPage extends StatelessWidget {
  final Episode episode;
  const EpisodeDetailPage({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Stack(
        children: [
          EpisodeDetailContent(
            episode: episode,
          ),
          Positioned(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset('assets/ic-navigate-back.svg'),
            ),
            top: kToolbarHeight / 2,
            left: 20,
          )
        ],
      ),
    );
  }
}

class EpisodeDetailContent extends StatelessWidget {
  const EpisodeDetailContent({
    Key? key,
    required this.episode,
  }) : super(key: key);

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;

    final CommentsBloc _commentsBloc = BlocProvider.of<CommentsBloc>(context);

    return Column(
      children: [
        Expanded(
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            child: CachedNetworkImage(
              fit: BoxFit.fitWidth,
              width: _deviceSize.width,
              height: _deviceSize.height * 0.2,
              imageUrl: 'https://api.infinum.academy' + episode.imageUrl,
              errorWidget: (ctx, url, err) => Center(
                child: PlatformText(err.toString()),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: AutoSizeText(
                  episode.title,
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.headline1!
                        .copyWith(fontWeight: FontWeight.w300),
                    cupertino: (data) => data.textTheme.navLargeTitleTextStyle
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  'S' +
                      episode.seasonNumber +
                      ' ' +
                      'Ep' +
                      episode.episodeNumber,
                  maxLines: 1,
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.bodyText1!.copyWith(
                      color: accentColor,
                    ),
                    cupertino: (data) => data.textTheme.textStyle.copyWith(
                      color: accentColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(episode.description),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _commentsBloc.add(FetchComments(episode.id));
                    Navigator.of(context)
                        .pushNamed(ROUTE_COMMENTS_PAGE, arguments: episode.id);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/ic-comments.svg'),
                      AutoSizeText(
                        'Comments',
                        style: platformThemeData(
                          context,
                          material: (data) => data.textTheme.bodyText1!,
                          cupertino: (data) => data.textTheme.textStyle,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
