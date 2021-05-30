import 'package:tw_shows/core/constants/networking.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/network_client.dart';
import 'package:tw_shows/functions/episodes/data/enteties/episode_model.dart';

abstract class NetworkEpisodesDataSource {
  Future<Map<String, dynamic>> fetchEpisode(String episodeId);
  Future<List<Map<String, dynamic>>> fetchShowEpisodes(String showId);
  Future<void> createNewEpisode(EpisodeModel episode);
}

class NetworkEpisodesDataSourceImpl extends NetworkEpisodesDataSource {
  final NetworkClient _networkClient;

  NetworkEpisodesDataSourceImpl(this._networkClient);

  @override
  Future<void> createNewEpisode(EpisodeModel episode) async {
    final _response = await _networkClient.client.post(
      ADDR_BASE + 'episodes/',
      data: episode.toJson(),
    );
    print(episode.toJson());
    if (!(_response.statusCode == 201 || _response.statusCode == 200))
      throw ServerException();
  }

  @override
  Future<Map<String, dynamic>> fetchEpisode(String episodeId) async {
    final _response =
        await _networkClient.client.get(ADDR_BASE + 'episodes/' + episodeId);
    if (!(_response.statusCode == 201 || _response.statusCode == 200))
      throw ServerException();
    return _response.data as Map<String, dynamic>;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchShowEpisodes(String showId) async {
    final _response = await _networkClient.client
        .get(ADDR_BASE + 'shows/' + showId + '/episodes');
    if (!(_response.statusCode == 201 || _response.statusCode == 200))
      throw ServerException();
    return (_response.data['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }
}
