import '../../../../core/error/exceptions/exceptions.dart';
import '../../../../core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../models/comment.dart';
import '../repositories/comments_repository.dart';

class LoadEpisodeCommentsUsecase
    extends Usecase<List<Comment>, CommentsParams> {
  final CommentsRepository _commentsRepository;

  LoadEpisodeCommentsUsecase(this._commentsRepository);

  @override
  Future<Either<Failure, List<Comment>>> call(CommentsParams params) async {
    try {
      final _comments =
          await _commentsRepository.getEpisodeComments(params.episodeId);
      return Right(_comments);
    } on NoConnectionException catch (_) {
      return Left(NoConnectionFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}

class CommentsParams extends Params {
  final String episodeId;

  CommentsParams(this.episodeId);

  @override
  List<Object?> get props => [episodeId];
}
