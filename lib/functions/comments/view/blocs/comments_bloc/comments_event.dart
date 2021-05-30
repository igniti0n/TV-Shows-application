part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();
}

class FetchComments extends CommentsEvent {
  final String episodeId;

  FetchComments(this.episodeId);

  @override
  List<Object> get props => [episodeId];
}
