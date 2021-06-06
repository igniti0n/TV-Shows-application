import '../models/comment.dart';

abstract class CommentsRepository {
  Future<List<Comment>> getEpisodeComments(String episodeId);
  Future<void> createNewComment(Comment comment);
}
