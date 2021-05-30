import 'package:tw_shows/functions/comments/domain/models/comment.dart';

abstract class CommentsRepository {
  Future<List<Comment>> getEpisodeComments(String episodeId);
  Future<void> createNewComment(Comment comment);
}
