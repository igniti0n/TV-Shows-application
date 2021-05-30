part of 'single_show_bloc.dart';

abstract class SingleShowEvent extends Equatable {
  const SingleShowEvent();

  @override
  List<Object> get props => [];
}

class FetchShow extends SingleShowEvent {
  final String showId;

  FetchShow(this.showId);
}
