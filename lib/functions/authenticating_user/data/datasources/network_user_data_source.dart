import 'package:dio/dio.dart';
import '../../../../core/constants/networking.dart';
import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/network/network_client.dart';
import '../entities/user_model.dart';

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
    else {
      _addTokenToInterceptor(_response);
    }
  }

  void _addTokenToInterceptor(Response<dynamic> _response) {
    final String _token =
        (_response.data['data'] as Map<String, dynamic>)['token'] as String;
    _networkClient.setInterceptorAuthHeader(_token);
  }

  @override
  Future<void> signOut() async {
    _networkClient.removeInterceptorAuthHeader();
  }
}
