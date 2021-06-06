import 'dart:io';

import 'package:image_picker/image_picker.dart' as ip;

abstract class ImagePicker {
  Future<String> pickImage(ip.ImageSource imageSource);
}

class ImagePickerimpl extends ImagePicker {
  final ip.ImagePicker imagePicker;

  ImagePickerimpl(this.imagePicker);

  @override
  Future<String> pickImage(ip.ImageSource imageSource) async {
    final _pickedFile = await imagePicker.getImage(
        source: ip.ImageSource.camera); //, imageQuality: 100);
    if (_pickedFile != null) {
      final _image = File(_pickedFile.path);
      return _image.path;
    }
    return '';
  }
}
