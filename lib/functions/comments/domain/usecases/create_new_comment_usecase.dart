import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../models/comment.dart';
import '../repositories/comments_repository.dart';

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
