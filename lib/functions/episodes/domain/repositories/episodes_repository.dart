import 'package:tw_shows/functions/episodes/domain/models/episode.dart';

abstract class EpisodesRepository {
  Future<List<Episode>> fetchShowEpisodes(String showId);
  Future<Episode> fetchEpisode(String episodeId);
  Future<void> createNewEpisode(Episode episode);
}
