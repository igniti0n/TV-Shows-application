part of 'shows_bloc.dart';

@immutable
abstract class ShowsEvent extends Equatable {}

class FetchShows extends ShowsEvent {
  @override
  List<Object?> get props => [];
}
