import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures/failures.dart';
import '../../../domain/models/show.dart';
import '../../../domain/usecases/load_show_usecase_impl.dart';

part 'single_show_event.dart';
part 'single_show_state.dart';

class SingleShowBloc extends Bloc<SingleShowEvent, SingleShowState> {
  final LoadShowUsecase _loadShowUsecase;
  SingleShowBloc(this._loadShowUsecase) : super(SingleShowInitial());

  @override
  Stream<SingleShowState> mapEventToState(
    SingleShowEvent event,
  ) async* {
    yield SingleShowLoading();
    if (event is FetchShow) {
      final _either = await _loadShowUsecase(ShowParams(event.showId));
      yield _either.fold(
        (Failure failure) => SingleShowError(failure.message),
        (Show show) => SingleShowLoaded(show),
      );
    }
  }
}
