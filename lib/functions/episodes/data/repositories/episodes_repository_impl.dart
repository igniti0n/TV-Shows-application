import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../datasources/network_episodes_data_source.dart';
import '../enteties/episode_model.dart';
import '../../domain/models/episode.dart';
import '../../domain/repositories/episodes_repository.dart';

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
    final String _imageUrl = await _networkEpisodesDataSource
        .createNewEpisodeImage(episode.imageUrl);
    await _networkEpisodesDataSource.createNewEpisode(
        EpisodeModel.fromEpisode(episode.copyWith(imageUrl: _imageUrl)));
  }

  Future<void> _checkIfDeviceConnectedToInternet() async {
    if (!await _connectionChecker.hasConnection) throw NoConnectionException();
  }
}
