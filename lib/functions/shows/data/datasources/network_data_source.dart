import 'dart:convert';
import 'dart:developer';

import 'package:tw_shows/core/constants/networking.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/network_client.dart';

abstract class NetworkShowsDataSource {
  Future<Map<String, dynamic>> fetchAllShows();
  Future<Map<String, dynamic>> fetchShow(String showId);
}

class NetworkShowsDataSourceImpl extends NetworkShowsDataSource {
  final NetworkClient _networkClient;

  NetworkShowsDataSourceImpl(this._networkClient);

  @override
  Future<Map<String, dynamic>> fetchAllShows() async {
    final _response = await _networkClient.client.get(ADDR_BASE + 'shows');
    if (_response.statusCode != 200) throw ServerException();
    return _response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> fetchShow(String showId) async {
    final _response =
        await _networkClient.client.get(ADDR_BASE + 'shows/$showId');
    log('response data shows' + _response.data.toString());
    if (!(_response.statusCode != 200 || _response.statusCode != 201))
      throw ServerException();

    return _response.data as Map<String, dynamic>;
  }
}
