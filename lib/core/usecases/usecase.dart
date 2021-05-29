import 'package:tw_shows/core/error/failures/failures.dart';

import 'package:dartz/dartz.dart';



abstract class Usecase <Type, Params>{
  Future<Either<Failure, Type>> call(Params params);
}

