import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crianza_mutua/config/constants.dart';

class ImageHelper {
  static Future<File> pickImageFromGallery({
    @required BuildContext context,
    @required CropStyle cropStyle,
    @required String title,
  }) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        cropStyle: cropStyle,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: title,
          toolbarColor: kPrimarySwatch,
          toolbarWidgetColor: Colors.grey[150],
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(),
        compressQuality: 70,
      );
      return croppedFile;
    }
    return null;
  }
}
