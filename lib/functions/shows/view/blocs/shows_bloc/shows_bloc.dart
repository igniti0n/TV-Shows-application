import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/functions/shows/domain/models/show.dart';
import 'package:tw_shows/functions/shows/domain/usecases/load_shows_usecase_impl.dart';

part 'shows_event.dart';
part 'shows_state.dart';

class ShowsBloc extends Bloc<ShowsEvent, ShowsState> {
  final LoadShowsUsecase _loadShowsUsecase;
  ShowsBloc(this._loadShowsUsecase) : super(ShowsInitial());

  @override
  Stream<ShowsState> mapEventToState(
    ShowsEvent event,
  ) async* {
    if (event is FetchShows) {
      yield ShowsLoading();
      final _either = await _loadShowsUsecase(NoParams());
      yield _either.fold((Failure failure) => ShowsError(failure.message),
          (List<Show> shows) => ShowsLoaded(shows));
    }
  }
}
