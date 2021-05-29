import 'package:tw_shows/functions/shows/domain/models/show.dart';

class ShowModel extends Show {
  ShowModel({required String imageUrl,required String description,required String id,required String title,}) : super(description: description,id: id,imageUrl: imageUrl,title: title,);

}