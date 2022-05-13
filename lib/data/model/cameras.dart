import 'package:camera/camera.dart';

class Cameras {
  List<CameraDescription> cameras;

  Cameras({this.cameras});

  Cameras.fromMap(Map<List, dynamic> map) {
    cameras = map['cameras'];
  }
}
