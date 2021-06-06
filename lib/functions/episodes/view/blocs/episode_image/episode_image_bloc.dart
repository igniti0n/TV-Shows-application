import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/core/native/image_picker.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/pick_image_usecase.dart';

part 'episode_image_event.dart';
part 'episode_image_state.dart';

class EpisodeImageBloc extends Bloc<EpisodeImageEvent, EpisodeImageState> {
  final PickImageUsecase _pickImageUsecase;
  EpisodeImageBloc(this._pickImageUsecase) : super(EpisodeImageInitial());

  @override
  Stream<EpisodeImageState> mapEventToState(
    EpisodeImageEvent event,
  ) async* {
    if (event is StartImageSourcePicking) {
      yield ImageSourcePickingStarted(state.imagePath);
    } else if (event is StartImagePicking) {
      final _either =
          await _pickImageUsecase(PickImageParams(event.imageSource));
      yield _yieldImagePickingState(_either);
    } else if (event is ClearImage) {
      yield EpisodeImageInitial();
    }
  }

  EpisodeImageState _yieldImagePickingState(Either<Failure, String> _either) {
    return _either.fold(
      (Failure failure) => ImagePickingError(failure.message, state.imagePath),
      (String filePath) => filePath.isEmpty
          ? ImageNotPicked(state.imagePath)
          : ImagePicked(filePath),
    );
  }
}
