import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../datasource/network_comments_data_source.dart';
import '../enteties/comment_model.dart';
import '../../domain/models/comment.dart';
import '../../domain/repositories/comments_repository.dart';

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
