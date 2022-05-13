import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as i;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:emed/screen/picture_display/picture_display_screen.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emed/shared/widget/my_icon.dart';
import "package:emed/screen/drug/drug_detail_logic.dart";

class ImageButton extends StatefulWidget {
  String imageUrl;
  bool uploadedImage;
  bool isCropped; // if image get from cropped -> true
  Function setImagePathLocal;
  var coord;
  String drugId;
  String userId;
  int index;
  ImageButton({
    this.imageUrl,
    this.uploadedImage = false,
    this.setImagePathLocal,
    this.coord,
    this.index = 0,
    this.drugId,
    this.userId,
    this.isCropped,
  });

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  String imageUrl;
  bool uploadedImage;
  Image croppedImage;
  String croppedImageDir;
  final _fireStorageInstance = FirebaseStorage.instance;

  var coord;
  @override
  void initState() {
    // TODO: implement initState
    // imageUrl = this.widget.imageUrl;
    // if (widget.imageUrl != null && !this.widget.imageUrl.startsWith('images/'))
    //   imageUrl = this.widget.imageUrl;
    // if (this.widget.coord != null) {
    //   this.coord = this.widget.coord;
    //   this.croppedImage = _getCrops();
    // }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print('Duyna [IMAGE BUTTON]: init state...');

      if (this.widget.imageUrl != null && this.widget.uploadedImage == true) {
        final imageFirestore = await DrugDetailScreenLogic()
            .getUrlUpdate(imagePath: this.widget.imageUrl);
        print('Duyna: The full path url: ${imageFirestore.toString()}');

        setState(() {
          imageUrl = imageFirestore;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl != null && !this.widget.imageUrl.startsWith('images/'))
      imageUrl = this.widget.imageUrl;

    if (this.widget.coord != null) {
      this.coord = this.widget.coord;
      this.croppedImage = _getCrops();
    }

    return InkWell(
      onTap: () => _navigateToCamera(),
      child: imageUrl == null || imageUrl == ""
          ? Container(
              width: 45.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: kPrimaryDarkColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                child: MyIcon(
                  svgIconPath: 'assets/icons/camera.svg',
                  color: Color.fromRGBO(115, 115, 115, 1),
                ),
              ),
            )
          : Container(
              width: 45.w,
              height: 45.h,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: kPrimaryDarkColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: _loadImageFromPath(),
            ),
    );
  }

  _loadImageFromPath() {
    print('Duyna: The build method triggered!');
    //neu co coord thi tra ve anh crop
    if (coord != null) {
      print('DUYNA: The coord received inside imgbtn: ${widget.coord}');
      return FittedBox(child: this.croppedImage, fit: BoxFit.contain);
    }
    // neu co anh duoi local thi lay anh duoi local
    if (imageUrl.startsWith('/data/') || imageUrl.startsWith('/storage/')) {
      print('Duyna: from local');
      return FittedBox(child: Image.file(File(imageUrl)), fit: BoxFit.fill);
    } else {
      print('Duyna: from network');
      return FittedBox(child: Image.network(imageUrl), fit: BoxFit.fill);
    }
  }

  _getCropImgFilePath(String filePath) {
    final image = i.decodeImage(File(imageUrl).readAsBytesSync());

    final x = (coord['x_min']).toInt();
    final y = (coord['y_min']).toInt();
    final w = (coord['x_max'] - coord['x_min']).toInt();
    final h = (coord['y_max'] - coord['y_min']).toInt();

    // final x = 0;
    // final y = 0;
    // final w = 1500;
    // final h = 1500;

    print('Duyna: The rect pos: $x $y $w $h');
    final cropped = i.copyCrop(image, x, y, w, h);
    // File('tmp.png').writeAsBytesSync(i.encodePng(cropped));
    // return Image.file(File('tmp.png'));

    // return Image.memory(Uint8List.fromList(i.encodePng(cropped)));
    Uint8List bodyBytes = Uint8List.fromList(i.encodePng(cropped));
    File(filePath).writeAsBytesSync(bodyBytes);
  }

  _getCrops() {
    final image = i.decodeImage(File(imageUrl).readAsBytesSync());

    final x = (coord['x_min']).toInt();
    final y = (coord['y_min']).toInt();
    final w = (coord['x_max'] - coord['x_min']).toInt();
    final h = (coord['y_max'] - coord['y_min']).toInt();

    // final x = 0;
    // final y = 0;
    // final w = 1500;
    // final h = 1500;

    print('Duyna: The rect pos: $x $y $w $h');
    final cropped = i.copyCrop(image, x, y, w, h);
    // File('tmp.png').writeAsBytesSync(i.encodePng(cropped));
    // return Image.file(File('tmp.png'));

    return Image.memory(Uint8List.fromList(i.encodePng(cropped)));
  }

  _navigateToCamera() async {
    // neu khong ton tai imagePath
    if (imageUrl == null || imageUrl == '') {
      // day sang luong chup anh
      final imagePath = await NavigationService()
          .pushNamed(ROUTER_CAPTURE, arguments: {'isPill': true});

      // check link anh da chup ton tai
      if (imagePath != null && imagePath != '') {
        if (widget.setImagePathLocal != null) {
          widget.setImagePathLocal(imagePath: imagePath, index: widget.index);
          setState(() {
            imageUrl = imagePath;
          });
        }
        // neu muon up anh len firebase
        if (widget.uploadedImage) {
          // upload anh len firebase
          await uploadImagePill(
              path: imagePath, imagePathFirestore: this.widget.imageUrl);
          String prescriptionImgUrl = await DrugDetailScreenLogic()
              .getUrlUpdate(imagePath: this.widget.imageUrl);
          setState(() {
            imageUrl = prescriptionImgUrl;
          });
        } else {
          setState(() {
            imageUrl = imagePath;
          });
        }
      }
    } else {
      // neu ton tai imagepath thi chuyen sang luong hien thi anh
      final imagePath = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DisplayPictureScreen(imagePath: imageUrl, isPill: true)));

      if (imagePath != null && imagePath != '') {
        if (widget.setImagePathLocal != null) {
          widget.setImagePathLocal(imagePath: imagePath, index: widget.index);
        }
        if (widget.uploadedImage) {
          await uploadImagePill(
              path: imagePath, imagePathFirestore: this.widget.imageUrl);
          String prescriptionImgUrl = await DrugDetailScreenLogic()
              .getUrlUpdate(imagePath: this.widget.imageUrl);
          setState(() {
            imageUrl = prescriptionImgUrl;
          });
        } else {
          setState(() {
            imageUrl = imagePath;
          });
        }
      }
    }
  }

  Future<String> uploadImagePill(
      {String path, String imagePathFirestore}) async {
    final img = File(path);
    final String filePath = imagePathFirestore;

    try {
      final uploadedImgTask =
          await _fireStorageInstance.ref(filePath).putFile(img);
      if (uploadedImgTask.state == TaskState.success) {
        print('hungvv  - task success');
        return filePath;
      } else {
        return '';
      }
    } on FirebaseException catch (e) {
      print(e);
      return '';
    } catch (anotherException) {
      print(anotherException);
      return '';
    }
  }
}
