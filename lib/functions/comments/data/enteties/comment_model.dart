import 'package:tw_shows/functions/comments/domain/models/comment.dart';

class CommentModel extends Comment {
  CommentModel(String text, String episodeId) : super(text, episodeId);

  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(map['text'], map['episodeId']);
  }

  factory CommentModel.fromComment(Comment comment) {
    return CommentModel(comment.text, comment.episodeId);
  }

  Map<String, dynamic> toJson() {
    return {
      'text': this.text,
      'episodeId': this.episodeId,
    };
  }
}
