part of 'episode_image_bloc.dart';

abstract class EpisodeImageState extends Equatable {
  final String imagePath;
  const EpisodeImageState(this.imagePath);
}

class EpisodeImageInitial extends EpisodeImageState {
  EpisodeImageInitial() : super('');

  @override
  List<Object> get props => [imagePath];
}

class ImageSourcePickingStarted extends EpisodeImageState {
  ImageSourcePickingStarted(String imagePath) : super(imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ImagePicked extends EpisodeImageState {
  ImagePicked(String filePath) : super(filePath);

  @override
  List<Object?> get props => [imagePath];
}

class ImageNotPicked extends EpisodeImageState {
  ImageNotPicked(String imagePath) : super(imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ImagePickingError extends EpisodeImageState {
  final String message;

  ImagePickingError(this.message, String imagePath) : super(imagePath);
  @override
  List<Object> get props => [message, imagePath];
}
