import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tw_shows/core/constants/pages.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episode_form_bloc/episode_form_bloc.dart';
import 'package:tw_shows/functions/shows/view/blocs/single_show_bloc/single_show_bloc.dart';
import 'package:tw_shows/functions/shows/view/widgets/show_details/show_detail_content.dart';

class ShowDetailsPage extends StatelessWidget {
  const ShowDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Stack(
        children: [
          ShowDetialContent(),
          Positioned(
            child: GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(ROUTE_SHOWS_PAGE),
              child: SvgPicture.asset('assets/ic-navigate-back.svg'),
            ),
            top: kToolbarHeight / 2,
            left: 20,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: BlocBuilder<SingleShowBloc, SingleShowState>(
              builder: (context, showState) {
                if (showState is SingleShowLoaded) {
                  return _buildSingleShowLoaded(context, showState);
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton _buildSingleShowLoaded(
      BuildContext context, SingleShowLoaded showState) {
    return FloatingActionButton(
      onPressed: () {
        BlocProvider.of<EpisodeFormBloc>(context)
            .add(EpisodeCreationScreenStarted(showState.show.id));
        Navigator.of(context).pushNamed(ROUTE_ADD_EPISODE_PAGE);
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
