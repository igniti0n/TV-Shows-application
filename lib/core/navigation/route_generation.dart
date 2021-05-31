import 'package:flutter/material.dart';
import 'package:tw_shows/core/constants/pages.dart';
import 'package:tw_shows/functions/authenticating_user/view/pages/authentication_page.dart';
import 'package:tw_shows/functions/comments/view/pages/comments_page.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/view/blocs/pages/add_episode_page.dart';
import 'package:tw_shows/functions/episodes/view/blocs/pages/episode_detal_page.dart';
import 'package:tw_shows/functions/shows/view/pages/show_details_page.dart';
import 'package:tw_shows/functions/shows/view/pages/shows_page.dart';

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ROUTE_AUTH_PAGE:
      return MaterialPageRoute(builder: (_) => AuthenticationPage());
    case ROUTE_SHOWS_PAGE:
      return MaterialPageRoute(builder: (_) => ShowsPage());
    case ROUTE_SHOW_DETAILS:
      return MaterialPageRoute(builder: (_) => ShowDetailsPage());
    case ROUTE_EPISODE_DETAILS:
      return MaterialPageRoute(
          builder: (_) => EpisodeDetailPage(
                episode: settings.arguments as Episode,
              ));
    case ROUTE_COMMENTS_PAGE:
      return MaterialPageRoute(
          builder: (_) => CommentsPage(
                episodeId: settings.arguments as String,
              ));
    case ROUTE_ADD_EPISODE_PAGE:
      return MaterialPageRoute(builder: (_) => AddEpisodePage());
    default:
      return MaterialPageRoute(builder: (_) => AuthenticationPage());
  }
}
