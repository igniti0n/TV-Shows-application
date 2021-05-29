import 'package:tw_shows/functions/episodes/domain/episode.dart';

class Show {
  final String imageUrl;
  final String id;
  final String title;
  final String description;

  Show({
    required this.imageUrl,
    required this.description,
    required this.title,
    required this.id,
  });
}
