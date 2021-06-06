import 'package:dio/dio.dart';
import '../../../../core/constants/networking.dart';
import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/network/network_client.dart';
import '../enteties/episode_model.dart';

abstract class NetworkEpisodesDataSource {
  Future<Map<String, dynamic>> fetchEpisode(String episodeId);
  Future<List<Map<String, dynamic>>> fetchShowEpisodes(String showId);
  Future<void> createNewEpisode(EpisodeModel episode);
  Future<String> createNewEpisodeImage(String filePath);
}

class NetworkEpisodesDataSourceImpl extends NetworkEpisodesDataSource {
  final NetworkClient _networkClient;

  NetworkEpisodesDataSourceImpl(this._networkClient);

  @override
  Future<void> createNewEpisode(EpisodeModel episode) async {
    final _data = episode.toJson()
      ..putIfAbsent('mediaId', () => episode.imageUrl);

    final _response = await _networkClient.client.post(
      ADDR_BASE + 'episodes/',
      data: _data,
    );
    _checkStatusCode(_response);
  }

  @override
  Future<String> createNewEpisodeImage(String filePath) async {
    final _formData = await _networkClient.createFormDataFromFile(filePath);

    final _response = await _networkClient.client.post(
      ADDR_BASE + 'media',
      data: _formData,
    );

    _checkStatusCode(_response);

    return _response.data['data']['_id'];
  }

  @override
  Future<Map<String, dynamic>> fetchEpisode(String episodeId) async {
    final _response =
        await _networkClient.client.get(ADDR_BASE + 'episodes/' + episodeId);
    _checkStatusCode(_response);
    return _response.data as Map<String, dynamic>;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchShowEpisodes(String showId) async {
    final _response = await _networkClient.client
        .get(ADDR_BASE + 'shows/' + showId + '/episodes');

    _checkStatusCode(_response);

    return (_response.data['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  void _checkStatusCode(Response<dynamic> _response) {
    if (!(_response.statusCode == 201 || _response.statusCode == 200))
      throw ServerException();
  }
}
