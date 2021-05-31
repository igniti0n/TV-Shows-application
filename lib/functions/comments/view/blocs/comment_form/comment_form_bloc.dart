import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';

part 'comment_form_event.dart';
part 'comment_form_state.dart';

class CommentFormBloc extends Bloc<CommentFormEvent, CommentFormState> {
  CommentFormBloc() : super(CommentFormInitial());

  @override
  Stream<CommentFormState> mapEventToState(
    CommentFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
