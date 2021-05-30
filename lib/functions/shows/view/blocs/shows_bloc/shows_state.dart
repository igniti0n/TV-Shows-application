part of 'shows_bloc.dart';

@immutable
abstract class ShowsState extends Equatable {}

class ShowsInitial extends ShowsState {
  @override
  List<Object?> get props => [];
}

class ShowsLoading extends ShowsState {
  @override
  List<Object?> get props => [];
}

class ShowsLoaded extends ShowsState {
  final List<Show> shows;

  ShowsLoaded(this.shows);

  @override
  List<Object?> get props => [shows];
}

class ShowsError extends ShowsState {
  final String message;

  ShowsError(this.message);

  @override
  List<Object?> get props => [message];
}
