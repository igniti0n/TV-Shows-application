import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/view/blocs/single_show_bloc/single_show_bloc.dart';
import 'package:tw_shows/functions/shows/view/widgets/show_details/show_information.dart';

import 'episodes_list.dart';

class ShowDetialContent extends StatelessWidget {
  const ShowDetialContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;

    return BlocBuilder<SingleShowBloc, SingleShowState>(
        builder: (ctx, showState) {
      if (showState is SingleShowLoaded) {
        return _buildLoaded(_deviceSize, showState.show, ctx);
      } else if (showState is SingleShowError) {
        return _buildSingleShowError(showState, context);
      }
      return Center(
        child: PlatformCircularProgressIndicator(),
      );
    });
  }

  Center _buildSingleShowError(
      SingleShowError showState, BuildContext context) {
    return Center(
      child: PlatformText(
        showState.message,
        style: platformThemeData(
          context,
          material: (data) => data.textTheme.bodyText1,
          cupertino: (data) => data.textTheme.textStyle,
        ),
      ),
    );
  }

  CustomScrollView _buildLoaded(
      Size _deviceSize, Show show, BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          // pinned: true,
          stretch: true,
          automaticallyImplyLeading: false,
          onStretchTrigger: () async =>
              BlocProvider.of<SingleShowBloc>(context).add(FetchShow(show.id)),
          expandedHeight: _deviceSize.height / 2.5,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [
              StretchMode.zoomBackground,
              StretchMode.blurBackground
            ],
            background: DecoratedBox(
              position: DecorationPosition.foreground,
              child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: 'https://api.infinum.academy' + show.imageUrl,
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
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: ShowInformation(
              deviceSize: _deviceSize,
              show: show,
            ),
          ),
        ),
        EpisodesList(show.id),
      ],
    );
  }
}
