part of 'comment_form_bloc.dart';

abstract class CommentFormState extends Equatable {
  // final Episode episode;
  const CommentFormState();

  @override
  List<Object> get props => [];
}

class CommentFormInitial extends CommentFormState {
  CommentFormInitial() : super();
}
