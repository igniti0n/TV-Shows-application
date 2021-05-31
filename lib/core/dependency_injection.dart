import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tw_shows/core/network/network_client.dart';
import 'package:tw_shows/core/storage/secure_storage_manager.dart';

import 'network/connection_checker.dart';

void initiDependenciesCore() {
  final _get = GetIt.instance;

  _get.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

  _get.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(_get()));

  _get.registerLazySingleton<NetworkClient>(() => NetworkClientImpl(_get()));

  _get.registerLazySingleton<Dio>(() => Dio());

  _get.registerLazySingleton<SecureStorageManager>(
      () => SecureStorageManagerImpl(_get()));

  _get.registerLazySingleton<FlutterSecureStorage>(
      () => FlutterSecureStorage());
}
