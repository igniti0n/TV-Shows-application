import 'package:tw_shows/core/constants/networking.dart';
import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/network/network_client.dart';
import 'package:tw_shows/functions/authenticating_user/data/entities/user_model.dart';

abstract class NetworkUserDataSource {
  Future<void> signIn(UserModel userModel);
  Future<void> signOut();
}

class NetworkUserDataSourceImpl extends NetworkUserDataSource {
  final NetworkClient _networkClient;

  NetworkUserDataSourceImpl(this._networkClient);

  @override
  Future<void> signIn(UserModel userModel) async {
    final _response = await _networkClient.client
        .post(ADDR_BASE + 'users/sessions', data: userModel.toJson());

    if (!(_response.statusCode == 200 || _response.statusCode == 201))
      throw ServerException();
  }

  @override
  Future<void> signOut() async {
    _networkClient.removeInterceptorAuthHeader();
  }
}