part of 'episode_image_bloc.dart';

abstract class EpisodeImageEvent extends Equatable {
  const EpisodeImageEvent();

  @override
  List<Object> get props => [];
}

class StartImageSourcePicking extends EpisodeImageEvent {}

class StartImagePicking extends EpisodeImageEvent {
  final ip.ImageSource imageSource;

  StartImagePicking(this.imageSource);

  @override
  List<Object> get props => [imageSource];
}

class ClearImage extends EpisodeImageEvent {}
