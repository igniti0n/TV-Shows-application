import 'package:dio/dio.dart';
import '../../../../core/constants/networking.dart';
import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/network/network_client.dart';
import '../enteties/comment_model.dart';

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
    _checkStatusCode(_response);
  }

  @override
  Future<List<Map<String, dynamic>>> getEpisodeComments(
      String episodeId) async {
    final _response = await _networkClient.client
        .get(ADDR_BASE + 'episodes/' + episodeId + '/comments');

    _checkStatusCode(_response);
    return (_response.data['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  void _checkStatusCode(Response<dynamic> _response) {
    if (!(_response.statusCode == 201 || _response.statusCode == 200))
      throw ServerException();
  }
}
