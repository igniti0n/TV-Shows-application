import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final String description;
  final String imageUrl;
  final String id;
  final String showId;
  final String title;
  final String seasonNumber;
  final String episodeNumber;

  Episode({
    required this.description,
    required this.imageUrl,
    required this.title,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.id,
    required this.showId,
  });

  Episode copyWith({
    String? description,
    String? imageUrl,
    String? id,
    String? showId,
    String? title,
    String? seasonNumber,
    String? episodeNumber,
  }) {
    return Episode(
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      id: id ?? this.id,
      showId: showId ?? this.showId,
    );
  }

  bool isValid() {
    return (description.isNotEmpty &&
        title.isNotEmpty &&
        seasonNumber.isNotEmpty &&
        episodeNumber.isNotEmpty &&
        imageUrl.isNotEmpty);
  }

  @override
  List<Object?> get props =>
      [id, showId, title, seasonNumber, episodeNumber, imageUrl, description];
}
