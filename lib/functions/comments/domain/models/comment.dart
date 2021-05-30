import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String text;
  final String episodeId;

  Comment(this.text, this.episodeId);

  @override
  List<Object?> get props => [
        text,
        episodeId,
      ];
}
