import 'dart:io';

import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/widget/my_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final bool isPill;

  const DisplayPictureScreen({Key key, this.imagePath, this.isPill})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String imagePath;
  @override
  void initState() {
    // TODO: implement initState
    imagePath = this.widget.imagePath;
  }

  Widget _renderImage(imagePath) {
    if (imagePath.startsWith('/data/') || imagePath.startsWith('/storage/')) {
      return FittedBox(
          child: Image.file(File(imagePath), width: 300.w, height: 500.h),
          fit: BoxFit.none);
    } else {
      return FittedBox(
          child: Image.network(imagePath, width: 300.w, height: 500.h),
          fit: BoxFit.none);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ảnh đơn thuốc'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, imagePath),
        ),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            SizedBox(height: 20.h),
            InteractiveViewer(
              panEnabled: false, // Set it to false to prevent panning.
              boundaryMargin: EdgeInsets.all(80),
              minScale: 1,
              maxScale: 4,
              child: _renderImage(imagePath),
            ),
            SizedBox(
              height: 20.h,
            ),
            this.widget.isPill
                ? FlatButton(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        MyIcon(
                          svgIconPath: 'assets/icons/camera.svg',
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text("Chụp lại",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 14.0)),
                      ],
                    ),
                    color: Color.fromRGBO(26, 173, 187, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () => _navigateToCamera())
                : SizedBox(),
          ]),
        ],
      ),
    );
  }

  _navigateToCamera() async {
    final imagePath = await NavigationService()
        .pushNamed(ROUTER_CAPTURE, arguments: {'isPill': widget.isPill});
    if (imagePath != null && imagePath != '')
      setState(() {
        this.imagePath = imagePath;
      });
  }
}
