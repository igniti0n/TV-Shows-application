import 'package:tw_shows/functions/episodes/domain/models/episode.dart';

class EpisodeModel extends Episode {
  EpisodeModel({
    required String description,
    required String imageUrl,
    required String id,
    required String showId,
    required String title,
    required String seasonNumber,
    required String episodeNumber,
  }) : super(
          description: description,
          episodeNumber: episodeNumber,
          id: id,
          imageUrl: imageUrl,
          showId: showId,
          seasonNumber: seasonNumber,
          title: title,
        );

  factory EpisodeModel.fromJson(Map<String, dynamic> map) {
    return EpisodeModel(
      description: map['description'],
      imageUrl: map['imageUrl'],
      title: map['title'],
      seasonNumber: map['season'],
      episodeNumber: map['episodeNumber'],
      id: map['_id'],
      showId: map['showId'] ?? '',
    );
  }

  factory EpisodeModel.fromEpisode(Episode episode) {
    return EpisodeModel(
      description: episode.description,
      imageUrl: episode.imageUrl,
      title: episode.title,
      seasonNumber: episode.seasonNumber,
      episodeNumber: episode.episodeNumber,
      id: episode.id,
      showId: episode.showId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "showId": this.showId,
      "title": this.title,
      "description": this.description,
      "episodeNumber": this.episodeNumber,
      "season": this.seasonNumber,
      "imageUrl": this.imageUrl,
    };
  }
}
