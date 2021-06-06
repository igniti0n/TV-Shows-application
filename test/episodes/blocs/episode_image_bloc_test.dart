//@dart=2.9

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:tw_shows/core/constants/error_messages.dart';
import 'package:tw_shows/core/error/failures/failures.dart';
import 'package:tw_shows/core/native/image_picker.dart';
import 'package:tw_shows/functions/episodes/domain/models/episode.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/pick_image_usecase.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episode_form_bloc/episode_form_bloc.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episode_image/episode_image_bloc.dart';
import 'package:tw_shows/functions/episodes/view/blocs/episodes_bloc/episodes_bloc.dart';
import 'package:tw_shows/functions/episodes/domain/usecases/load_show_episodes_usecase.dart';

class MockPickImageUsecase extends Mock implements PickImageUsecase {}

void main() {
  MockPickImageUsecase _mockImagePicker;

  setUpAll(() {
    _mockImagePicker = MockPickImageUsecase();
  });

  final String _testImagePath = 'iamge_path';

  final String _testTitle = 'title';

  final String _testDescription = 'desciption';

  final String _testEpisodeNumber = 'S4&E4';

  final _testEpisodeInitial = Episode(
      description: '',
      imageUrl: '',
      title: '',
      seasonNumber: '',
      episodeNumber: '',
      id: '',
      showId: '');

  blocTest(
    'should emit [ImageSourcePickingStarted] when StartImageSourcePicking event',
    build: () {
      return EpisodeImageBloc(_mockImagePicker);
    },
    act: (EpisodeImageBloc bloc) => bloc.add(StartImageSourcePicking()),
    expect: () => [
      ImageSourcePickingStarted(''),
    ],
  );

  blocTest(
    'should emit [ImageNotPicked] when StartImagePicking event doe snot pick image',
    build: () {
      when(() => _mockImagePicker(PickImageParams(ip.ImageSource.camera)))
          .thenAnswer((_) async => Right(''));
      return EpisodeImageBloc(_mockImagePicker);
    },
    act: (EpisodeImageBloc bloc) =>
        bloc.add(StartImagePicking(ip.ImageSource.camera)),
    expect: () => [
      ImageNotPicked(''),
    ],
  );

  blocTest(
    'should emit [ImagePicked] when StartImagePicking event pickes images',
    build: () {
      when(() => _mockImagePicker(PickImageParams(ip.ImageSource.camera)))
          .thenAnswer((_) async => Right(_testImagePath));
      return EpisodeImageBloc(_mockImagePicker);
    },
    act: (EpisodeImageBloc bloc) =>
        bloc.add(StartImagePicking(ip.ImageSource.camera)),
    expect: () => [
      ImagePicked(_testImagePath),
    ],
  );

  blocTest(
    'should emit [ImagePickingError] when ImagePickingFailure with ERR_IMAGE_PICKING message',
    build: () {
      when(() => _mockImagePicker(PickImageParams(ip.ImageSource.camera)))
          .thenAnswer((_) async => Left(ImagePickingFailure()));
      return EpisodeImageBloc(_mockImagePicker);
    },
    act: (EpisodeImageBloc bloc) =>
        bloc.add(StartImagePicking(ip.ImageSource.camera)),
    expect: () => [
      ImagePickingError(ERROR_IMAGE_PICKING, ''),
    ],
  );
}
