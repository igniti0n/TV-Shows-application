part of 'comment_post_bloc.dart';

abstract class CommentPostState extends Equatable {
  const CommentPostState();
}

class CommentPostInitial extends CommentPostState {
  @override
  List<Object> get props => [];
}

class CommentPostLoading extends CommentPostState {
  @override
  List<Object> get props => [];
}

class CommentPostSuccess extends CommentPostState {
  @override
  List<Object> get props => [];
}

class CommentPostFail extends CommentPostState {
  final String message;

  CommentPostFail(this.message);
  @override
  List<Object> get props => [];
}
