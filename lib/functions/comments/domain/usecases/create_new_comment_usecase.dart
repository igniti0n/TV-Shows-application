import 'package:tw_shows/core/error/exceptions/exceptions.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/core/usecases/usecase.dart';
import 'package:tw_shows/functions/comments/domain/models/comment.dart';
import 'package:tw_shows/functions/comments/domain/repositories/comments_repository.dart';

class CreateNewCommentUsecase extends Usecase<void, CommentParams> {
  final CommentsRepository _commentsRepository;

  CreateNewCommentUsecase(this._commentsRepository);

  @override
  Future<Either<Failure, void>> call(CommentParams params) async {
    try {
      await _commentsRepository.createNewComment(params.comment);
      return Right(NoParams());
    } on NoConnectionException catch (_) {
      return Left(NoConnectionFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}

class CommentParams extends Params {
  final Comment comment;

  CommentParams(this.comment);
  @override
  List<Object?> get props => [comment];
}
