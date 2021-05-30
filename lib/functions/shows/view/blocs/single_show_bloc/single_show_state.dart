part of 'single_show_bloc.dart';

abstract class SingleShowState extends Equatable {
  const SingleShowState();

  @override
  List<Object> get props => [];
}

class SingleShowInitial extends SingleShowState {}

class SingleShowLoading extends SingleShowState {}

class SingleShowLoaded extends SingleShowState {
  final Show show;

  SingleShowLoaded(this.show);
}

class SingleShowError extends SingleShowState {
  final String message;

  SingleShowError(this.message);
}
