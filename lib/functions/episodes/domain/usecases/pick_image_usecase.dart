import 'package:image_picker/image_picker.dart' as ip;
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tw_shows/core/native/image_picker.dart';
import 'package:tw_shows/core/usecases/params.dart';
import 'package:tw_shows/core/usecases/usecase.dart';

class PickImageUsecase extends Usecase<String, PickImageParams> {
  final ImagePicker _imagePicker;

  PickImageUsecase(this._imagePicker);

  @override
  Future<Either<Failure, String>> call(PickImageParams params) async {
    try {
      final _imagePath = await _imagePicker.pickImage(params.imageSource);
      return Right(_imagePath);
    } catch (err) {
      return Left(ImagePickingFailure());
    }
  }
}

class PickImageParams extends Params {
  final ip.ImageSource imageSource;

  PickImageParams(this.imageSource);

  @override
  List<Object?> get props => [imageSource];
}
