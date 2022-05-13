import 'dart:io';

import 'package:image/image.dart';

extension FileExtension on File {
  Image toImage() {
    return decodeImage(this.readAsBytesSync());
  }
}