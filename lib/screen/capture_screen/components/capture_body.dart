import 'dart:io';

import 'package:emed/provider/model/camera_model.dart';
import 'package:emed/screen/capture_screen/components/camera_screen.dart';
import 'package:emed/screen/ocr_result/ocr_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:emed/screen/capture_screen/components/capture_navbar.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/setting/app_router.dart';

class CaptureBody extends StatefulWidget {
  final isPill;
  CaptureBody(this.isPill);

  @override
  _CaptureBodyState createState() => _CaptureBodyState();
}

class _CaptureBodyState extends State<CaptureBody> {
  GlobalKey<CameraScreenState> _keyCameraScreenState = GlobalKey();
  @override
  void initState() {
    super.initState();
    context.read<CameraModel>().getCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraModel>(
        builder: (BuildContext context, model, Widget child) {
      final _cameras = model.cameras;
      return SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              _cameras.isEmpty
                  ? Expanded(
                      child: Center(child: CircularProgressIndicator()),
                      flex: 4,
                    )
                  : Expanded(
                      child: CameraScreen(
                        key: _keyCameraScreenState,
                        cameras: _cameras,
                        pressClose: _pressCloseCapture,
                      ),
                      flex: 4,
                    ),
              Expanded(
                child: CaptureNavbar(
                  pressGetImage: _pressGetImage,
                  pressCaptureImage: _pressCaptureImage,
                  pressDirectInstruction: _pressDirectInstruction,
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      );
    });
  }

  void _pressDirectInstruction() {
    NavigationService().pushNamed(ROUTER_INSTRUCTION);
  }

  void _pressCaptureImage() {
    // setState(() {});
    _keyCameraScreenState.currentState.captureImage(widget.isPill);
  }

  void _pressGetImage() {
    getImageFromGallery(widget.isPill);
  }

  // take picture then show captured image
  void getImageFromGallery(bool isPill) async {
    try {
      await _getImage().then((String filePath) {
        if (mounted) {
          setCameraResult(filePath, isPill);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> _getImage() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      // File _pickedImage = File(pickedFile.path);
      // return _pickedImage.path;
      final rImage =
          await FlutterExifRotation.rotateImage(path: pickedFile.path);
      return rImage.path;
    }
    return null;
  }

  void setCameraResult(String imagePath, bool isPill) {
    // print("Captured sucessfully");
    if (imagePath != null) {
      print('Duyna: setCameraResult -> isPill: ${isPill}');
      if (isPill == null || isPill == false)
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OcrResultScreen(image_path: imagePath)));
      else
        Navigator.pop(context, imagePath);
    } else {
      print('No path found.');
    }
  }

  void _pressCloseCapture() {
    print('alo alo alo alo alo alo alo alo ');
    NavigationService().pushReplacementNamed(ROUTER_MAIN);
  }
}
