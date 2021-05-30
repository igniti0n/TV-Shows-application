import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/connection_checker.dart';
import 'package:tw_shows/functions/comments/data/datasource/network_comments_data_source.dart';
import 'package:tw_shows/functions/comments/data/enteties/comment_model.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';
import 'package:tw_shows/functions/comments/domain/repositories/comments_repository.dart';

class CommentsRepositoryImpl extends CommentsRepository {
  final ConnectionChecker _connectionChecker;
  final NetworkCommentsDataSource _networkCommentsDataSource;

  CommentsRepositoryImpl(
      this._networkCommentsDataSource, this._connectionChecker);

  @override
  Future<void> createNewComment(Comment comment) async {
    await _checkIfDeviceConnectedToInternet();
    await _networkCommentsDataSource
        .createNewComment(CommentModel.fromComment(comment));
  }

  @override
  Future<List<Comment>> getEpisodeComments(String episodeId) async {
    await _checkIfDeviceConnectedToInternet();
    final _responseData =
        await _networkCommentsDataSource.getEpisodeComments(episodeId);
    return _responseData.map((e) => CommentModel.fromJson(e)).toList();
  }

  Future<void> _checkIfDeviceConnectedToInternet() async {
    if (!await _connectionChecker.hasConnection) throw NoConnectionException();
  }
}
