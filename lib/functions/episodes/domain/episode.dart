class Episode {
  final String description;
  final String imageUrl;
  final String id;
  final String showId;
  final String title;
  final String seasonNumber;
  final String episodeNumber;

  Episode( {
    required this.description,
    required this.imageUrl,
    required this.title,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.id,
    required this.showId,
  });
}
