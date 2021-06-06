import 'package:equatable/equatable.dart';
import '../../../episodes/domain/models/episode.dart';

class Show extends Equatable {
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

  @override
  List<Object?> get props => [id, title, imageUrl, description];
}
