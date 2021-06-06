import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/network/connection_checker.dart';
import '../datasources/network_data_source.dart';
import '../enteties/show_model.dart';
import '../../domain/models/show.dart';
import '../../domain/repositories/shows_repository.dart';

class ShowsRepositoryImpl extends ShowsRepository {
  final ConnectionChecker _connectionChecker;
  final NetworkShowsDataSource _networkShowsDataSource;

  ShowsRepositoryImpl(this._connectionChecker, this._networkShowsDataSource);

  @override
  Future<List<Show>> fetchAllShows() async {
    await _checkIsConnectedToInternet();
    final _res = await _networkShowsDataSource.fetchAllShows();

    final List<Map<String, dynamic>> _showList =
        (_res['data'] as List<dynamic>).cast<Map<String, dynamic>>();

    final List<Show> _shows =
        _showList.map((e) => ShowModel.fromJson(e)).toList();

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
