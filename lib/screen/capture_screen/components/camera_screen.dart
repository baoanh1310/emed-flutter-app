import 'dart:io';

import 'package:emed/screen/ocr_result/ocr_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class CameraScreen extends StatefulWidget {
  List<CameraDescription> cameras;
  Function pressClose;
  CameraScreen({
    Key key,
    this.cameras,
    this.pressClose,
  }) : super(key: key);
  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  String imagePath;
  CameraController _controller;

  PermissionStatus _permissionCameraStatus;
  PermissionStatus _permissionStorageStatus;

  // PermissionHandler _permissionHandler = PermissionHandler();

  @override
  void initState() {
    super.initState();
    // context.read<CameraModel>().getCameras();
    // To display the current output from the camera,
    // create a CameraController.
    // print(widget.cameras.first.name);
    print('oninit: ${imagePath}');
    // imagePath = null;
    onCameraSelected(widget.cameras.elementAt(0));
    // Next, initialize the controller. This returns a Future.
    WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (widget.cameras.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No Camera Found',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Container(
      child: new Stack(
        // fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          new Positioned.fill(
            child: new AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: new CameraPreview(_controller)),
          ),
          Container(
            width: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 450.h,
                maxWidth: 450.w,
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: ImageIcon(
                  AssetImage("assets/images/camera_focus.png"),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.all(10.w),
              width: 66.w,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 33.w,
                  maxHeight: 33.w,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: widget.pressClose,
                  iconSize: 33.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onLayoutDone(Duration timeStamp) async {
    _permissionCameraStatus = await Permission.camera.status;
    _permissionStorageStatus = await Permission.storage.status;

    if (_permissionCameraStatus.isGranted ||
        _permissionStorageStatus.isGranted) {
      print('hungvv - $_permissionCameraStatus');
      print('hungvv - $_permissionStorageStatus');
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.storage,
      ].request();
    }
  }

  // trong phien ban dau tien, lay camera truoc
  void onCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) await _controller.dispose();
    _controller = CameraController(cameraDescription, ResolutionPreset.max,
        enableAudio: false);

    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showMessage('Camera Error: ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
      await _controller.lockCaptureOrientation(); // fix loi crash
    } on CameraException catch (e) {
      showException(e);
    }

    if (mounted) setState(() {});
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  // take picture then show captured image
  void captureImage(bool isPill) async {
    try {
      await _takePicture().then((String filePath) {
        // var image = File(filePath);
        if (mounted) {
          setState(() {
            print('Duyna: get file path: ${filePath}');
            imagePath = filePath;
            // imagePath = image.path;
          });
          setCameraResult(filePath, isPill);
          // setCameraResult(image.path, isPill);

          // if (filePath != null) {
          //   showMessage('Picture saved to $filePath');
          // }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  /*// take picture then show captured image
  void getImageFromGallery(bool isPill) async {
    try {
      await _getImage().then((String filePath) {
        if (mounted) {
          setState(() {
            print('Duyna: get file path: ${filePath}');
            imagePath = filePath;
          });
          setCameraResult(filePath, isPill);
          // if (filePath != null) {
          //   showMessage('Picture saved to $filePath');
          //   setCameraResult(filePath);
          // }
        }
      });
    } catch (e) {
      print(e);
    }
  }*/

  void setCameraResult(String imagePath, bool isPill) {
    // print("Captured sucessfully");
    if (imagePath != null) {
      // NavigationService().pushReplacementNamed(ROUTER_CAPTURE);
      // NavigationService().pushReplacementNamed(OCR_RESULT, image: imagePath);
      print('Duyna: isPill: ${isPill}');
      if (isPill == null || isPill == false)
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OcrResultScreen(image_path: imagePath)));
      else
        Navigator.pop(context, imagePath);
    } else {
      showMessage('No path found.');
    }
  }

  // init camera then take picture then return image path
  Future<String> _takePicture() async {
    if (!_controller.value.isInitialized) {
      showMessage('Error: select a camera first.');
      return null;
    }
    // final Directory extDir = await getApplicationDocumentsDirectory();
    // final String dirPath = '${extDir.path}/FlutterDevs/Camera/Images';
    // await new Directory(dirPath).create(recursive: true);
    // final String filePath = '$dirPath/${timestamp()}.jpg';

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final image = await _controller.takePicture();
      final rImage = await FlutterExifRotation.rotateImage(path: image.path);
      // print('THE FILE PATH BEFORE: ${path}');
      await GallerySaver.saveImage(rImage.path);
      // print('THE FILE PATH AFTER: ${path}');

      return rImage.path;
    } on CameraException catch (e) {
      showException(e);
      return null;
    }
  }

  /*Future<String> _getImage() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File _pickedImage = File(pickedFile.path);
      return _pickedImage.path;
    }
    return null;
  }*/

  void showException(CameraException e) {
    logError(e.code, e.description);
    showMessage('Error: ${e.code}\n${e.description}');
  }

  void showMessage(String message) {
    print(message);
  }

  void logError(String code, String message) =>
      print('Error: $code\nMessage: $message');
}
