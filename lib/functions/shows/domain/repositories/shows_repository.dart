import '../models/show.dart';

abstract class ShowsRepository {
  Future<List<Show>> fetchAllShows();

  Future<Show> fetchShow(String showId);
}
