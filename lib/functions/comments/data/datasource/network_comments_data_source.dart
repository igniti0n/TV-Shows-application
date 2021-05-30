import 'package:tw_shows/core/constants/networking.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/network_client.dart';
import 'package:tw_shows/functions/comments/data/enteties/comment_model.dart';
import 'package:tw_shows/functions/episodes/data/enteties/episode_model.dart';

abstract class NetworkCommentsDataSource {
  Future<List<Map<String, dynamic>>> getEpisodeComments(String episodeId);
  Future<void> createNewComment(CommentModel commentModel);
}

class NetworkCommentsDataSourceImpl extends NetworkCommentsDataSource {
  final NetworkClient _networkClient;

  NetworkCommentsDataSourceImpl(this._networkClient);

  @override
  Future<void> createNewComment(CommentModel commentModel) async {
    final _response = await _networkClient.client.post(
      ADDR_BASE + 'comments',
      data: commentModel.toJson(),
    );
    if (!(_response.statusCode == 201 || _response.statusCode == 200))
      throw ServerException();
  }

  @override
  Future<List<Map<String, dynamic>>> getEpisodeComments(
      String episodeId) async {
    final _response = await _networkClient.client
        .get(ADDR_BASE + 'episodes/' + episodeId + '/comments');
    if (!(_response.statusCode == 201 || _response.statusCode == 200))
      throw ServerException();
    return (_response.data['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }
}
