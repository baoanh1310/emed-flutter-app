import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraModel extends ChangeNotifier {
  List<CameraDescription> cameras = [];

  Future getCameras() async {
    // List<CameraDescription> cameras = [];
    // cameras = Cameras(cameras: cameras) as List<CameraDescription>;
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      cameras = [];
      print(e);
      //logError(e.code, e.description);
    }
    notifyListeners();
  }
}
