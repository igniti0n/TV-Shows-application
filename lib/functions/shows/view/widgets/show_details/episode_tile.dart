import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_shows/core/constants/colors.dart';
import 'package:tw_shows/core/constants/pages.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';

class EpisodeTile extends StatelessWidget {
  const EpisodeTile({
    Key? key,
    required Episode currentEpisode,
    required this.deviceSize,
  })  : _currentEpisode = currentEpisode,
        super(key: key);

  final Episode _currentEpisode;

  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceSize.height * 0.08,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: AutoSizeText(
                'S' +
                    _currentEpisode.seasonNumber +
                    ' ' +
                    'Ep' +
                    _currentEpisode.episodeNumber,
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
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 4,
              child: AutoSizeText(
                _currentEpisode.title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  ROUTE_EPISODE_DETAILS,
                  arguments: _currentEpisode,
                ),
                child: SvgPicture.asset('assets/ic-episode-detail.svg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
