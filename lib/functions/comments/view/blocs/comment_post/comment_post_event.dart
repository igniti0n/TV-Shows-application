part of 'comment_post_bloc.dart';

abstract class CommentPostEvent extends Equatable {
  const CommentPostEvent();
}

class PostComment extends CommentPostEvent {
  final Comment comment;

  PostComment(this.comment);

  @override
  List<Object> get props => [comment];
}
