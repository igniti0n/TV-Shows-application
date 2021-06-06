import '../models/episode.dart';

abstract class EpisodesRepository {
  Future<List<Episode>> fetchShowEpisodes(String showId);
  Future<Episode> fetchEpisode(String episodeId);
  Future<void> createNewEpisode(Episode episode);
}
