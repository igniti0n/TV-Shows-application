import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/pages.dart';
import '../../../../comments/view/blocs/comments_bloc/comments_bloc.dart';
import '../../../domain/models/episode.dart';

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

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: _deviceSize.height / 2.5,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [
              StretchMode.zoomBackground,
              StretchMode.blurBackground
            ],
            background: _buildEpisodeDetailImage(_deviceSize),
          ),
        ),
        _buildEpisodeDetailTitle(context),
        _buildEpisodeDetailNumber(context),
        _buildEpisodeDetailDescription(context),
        _buildEpisodeDetailComments(_commentsBloc, context),
      ],
    );
  }

  SliverPadding _buildEpisodeDetailTitle(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: AutoSizeText(
          episode.title,
          style: platformThemeData(
            context,
            material: (data) =>
                data.textTheme.headline1!.copyWith(fontWeight: FontWeight.w400),
            cupertino: (data) => data.textTheme.navLargeTitleTextStyle
                .copyWith(fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  SliverPadding _buildEpisodeDetailComments(
      CommentsBloc _commentsBloc, BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      sliver: SliverToBoxAdapter(
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
                '  Comments',
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
    );
  }

  SliverPadding _buildEpisodeDetailDescription(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: AutoSizeText(
          episode.description,
          style: platformThemeData(
            context,
            material: (data) => data.textTheme.bodyText1!.copyWith(
              height: 1.5,
              color: fadedTextDarkerColor,
            ),
            cupertino: (data) => data.textTheme.textStyle.copyWith(
              height: 1.5,
              color: fadedTextDarkerColor,
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding _buildEpisodeDetailNumber(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: AutoSizeText(
          'S' + episode.seasonNumber + ' ' + 'Ep' + episode.episodeNumber,
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
    );
  }

  DecoratedBox _buildEpisodeDetailImage(Size _deviceSize) {
    return DecoratedBox(
      position: DecorationPosition.foreground,
      child: CachedNetworkImage(
        fit: BoxFit.fitWidth,
        width: _deviceSize.width,
        height: _deviceSize.height * 0.6,
        imageUrl: 'https://api.infinum.academy' + episode.imageUrl,
        placeholder: (ctx, text) => Container(
          color: accentColor,
          width: double.infinity,
          height: double.infinity,
          child: Center(child: PlatformCircularProgressIndicator()),
        ),
        errorWidget: (ctx, url, err) => Container(
          color: accentColor,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: PlatformText('No image to show.'),
          ),
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.center,
        ),
      ),
    );
  }
}
