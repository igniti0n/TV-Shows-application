import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/models/episode.dart';
import '../widgets/episode_details/episode_detail_content.dart';

class EpisodeDetailPage extends StatelessWidget {
  final Episode episode;
  const EpisodeDetailPage({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.white,
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
