import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/connection_checker.dart';
import 'package:tw_shows/functions/shows/data/datasources/network_data_source.dart';
import 'package:tw_shows/functions/shows/data/enteties/show_model.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/domain/repositories/shows_repository.dart';

class ShowsRepositoryImpl extends ShowsRepository {
  final ConnectionChecker _connectionChecker;
  final NetworkShowsDataSource _networkShowsDataSource;

  ShowsRepositoryImpl(this._connectionChecker, this._networkShowsDataSource);

  @override
  Future<List<Show>> fetchAllShows() async {
    await _checkIsConnectedToInternet();
    final _res = await _networkShowsDataSource.fetchAllShows();
    final List<Show> _shows = (_res['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((e) => ShowModel.fromJson(e))
        .toList();
    return _shows;
  }

  @override
  Future<Show> fetchShow(String showId) async {
    await _checkIsConnectedToInternet();
    final _res = await _networkShowsDataSource.fetchShow(showId);
    return ShowModel.fromJson(_res['data']);
  }

  Future<void> _checkIsConnectedToInternet() async {
    if (!await _connectionChecker.hasConnection) throw NoConnectionException();
  }
}
