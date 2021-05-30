import 'package:tw_shows/functions/shows/domain/models/show.dart';

class ShowModel extends Show {
  ShowModel({
    required String imageUrl,
    required String description,
    required String id,
    required String title,
  }) : super(
          description: description,
          id: id,
          imageUrl: imageUrl,
          title: title,
        );

  factory ShowModel.fromJson(Map<String, dynamic> map) {
    return ShowModel(
      imageUrl: map['imageUrl'],
      description: map['description'] ?? '',
      id: map['id'],
      title: map['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": this.id,
      "title": this.title,
      "imageUrl": this.imageUrl,
      "description": this.description,
    };
  }
}
