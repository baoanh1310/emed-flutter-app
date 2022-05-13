import 'package:flutter/cupertino.dart' hide Image;
import 'package:image/image.dart';

extension FileExtension on Image {
  /// [ratio] is ratio of the new image to the old one
  Image resizeWithPercent({@required double ratio}) {
    final int newWidth = (this.width * ratio).toInt();
    return copyResize(this, width: newWidth);
  }
}