import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tw_shows/core/constants/pages.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/view/blocs/single_show_bloc/single_show_bloc.dart';
import 'package:tw_shows/functions/shows/view/widgets/show_details/episodes_list.dart';
import 'package:tw_shows/functions/shows/view/widgets/show_details/show_information.dart';

class ShowDetailsPage extends StatelessWidget {
  const ShowDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Stack(
        children: [
          DetialContent(),
          Positioned(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset('assets/ic-navigate-back.svg'),
            ),
            top: kToolbarHeight / 2,
            left: 20,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(ROUTE_ADD_EPISODE_PAGE),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetialContent extends StatelessWidget {
  const DetialContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;

    return BlocBuilder<SingleShowBloc, SingleShowState>(
        builder: (ctx, showState) {
      if (showState is SingleShowLoaded) {
        return _buildLoaded(_deviceSize, showState.show, ctx);
      } else if (showState is SingleShowError) {
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
      return Center(
        child: PlatformCircularProgressIndicator(),
      );
    });
  }

  CustomScrollView _buildLoaded(
      Size _deviceSize, Show show, BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          leading: Container(),
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
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
