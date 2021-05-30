import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/connection_checker.dart';
import 'package:tw_shows/functions/episodes/data/datasources/network_episodes_data_source.dart';
import 'package:tw_shows/functions/episodes/data/enteties/episode_model.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/domain/repositories/episodes_repository.dart';

class EpisodesRepositoryImpl extends EpisodesRepository {
  final ConnectionChecker _connectionChecker;
  final NetworkEpisodesDataSource _networkEpisodesDataSource;

  EpisodesRepositoryImpl(
      this._connectionChecker, this._networkEpisodesDataSource);
  @override
  Future<Episode> fetchEpisode(String episodeId) async {
    await _checkIfDeviceConnectedToInternet();
    final _episodeData =
        await _networkEpisodesDataSource.fetchEpisode(episodeId);

    return EpisodeModel.fromJson(_episodeData['data']);
  }

  @override
  Future<List<Episode>> fetchShowEpisodes(String showId) async {
    await _checkIfDeviceConnectedToInternet();
    final _episodesData =
        await _networkEpisodesDataSource.fetchShowEpisodes(showId);
    return _episodesData.map((e) => EpisodeModel.fromJson(e)).toList();
  }

  @override
  Future<void> createNewEpisode(Episode episode) async {
    await _checkIfDeviceConnectedToInternet();
    await _networkEpisodesDataSource
        .createNewEpisode(EpisodeModel.fromEpisode(episode));
  }

  Future<void> _checkIfDeviceConnectedToInternet() async {
    if (!await _connectionChecker.hasConnection) throw NoConnectionException();
  }
}
