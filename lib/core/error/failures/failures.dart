import 'package:equatable/equatable.dart';
import 'package:tw_shows/core/constants/error_messages.dart';

abstract class Failure extends Equatable {
  abstract final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  @override
  String get message => ERROR_SERVER;
}

class NoConnectionFailure extends Failure {
  @override
  String get message => ERROR_NO_CONNECTION;
}

class LocalStorageFailure extends Failure {
  @override
  String get message => ERROR_STORAGE;
}
