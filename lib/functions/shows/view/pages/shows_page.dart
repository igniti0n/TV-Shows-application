import 'dart:ui';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/pages.dart';
import '../../../authenticating_user/view/auth_bloc/auth_bloc_bloc.dart';
import '../../../episodes/view/blocs/episodes_bloc/episodes_bloc.dart';
import '../../domain/models/show.dart';
import '../blocs/shows_bloc/shows_bloc.dart';
import '../blocs/single_show_bloc/single_show_bloc.dart';
import '../widgets/show_list_tile.dart';

class ShowsPage extends StatelessWidget {
  const ShowsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
    final SingleShowBloc _singleShowBloc =
        BlocProvider.of<SingleShowBloc>(context, listen: false);
    final EpisodesBloc _episodesBloc =
        BlocProvider.of<EpisodesBloc>(context, listen: false);

    return PlatformScaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  'Shows',
                  maxFontSize: 40,
                  style: platformThemeData(
                    context,
                    material: (data) => data.textTheme.headline1,
                    cupertino: (data) => data.textTheme.navLargeTitleTextStyle,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context).add(SignOut());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      ROUTE_AUTH_PAGE,
                      ModalRoute.withName('/'),
                    );
                  },
                  child: SvgPicture.asset('assets/ic-logout.svg'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ShowsBloc, ShowsState>(
              builder: (context, showsState) {
                if (showsState is ShowsLoading)
                  return Center(
                    child: PlatformCircularProgressIndicator(),
                  );
                else if (showsState is ShowsLoaded) {
                  final List<Show> _shows = showsState.shows;
                  return ListView.builder(
                    itemCount: _shows.length,
                    itemExtent: _screenSize.height * 0.2,
                    itemBuilder: (ctx, index) => ShowListTile(
                      show: _shows[index],
                      episodesBloc: _episodesBloc,
                      singleShowBloc: _singleShowBloc,
                      imageHeight: _screenSize.height * 0.4,
                      imageWidth: _screenSize.width * 0.2,
                      autoSizeGroup: _autoSizeGroup,
                    ),
                  );
                } else if (showsState is ShowsError) {
                  return Center(
                    child: AutoSizeText(showsState.message),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    ));
  }
}
