import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/drug_history_item_time.dart';
import 'package:emed/data/repository/prescription_repository.dart';
import 'package:emed/data/service_locator.dart';
import 'package:emed/provider/model/screen_reload_model.dart';
import 'package:emed/screen/pill_result/components/drug_list.dart';
import 'package:emed/shared/api/druglist_api.dart';
import 'package:emed/shared/api/update_api.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:emed/shared/widget/my_icon.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as i;

class PillResultCard extends StatefulWidget {
  String imagePath;
  final List<DrugHistoryItemTime> todayList;
  final DateTime selectedDate;

  PillResultCard({Key key, this.imagePath, this.todayList, this.selectedDate})
      : super(key: key);

  @override
  _PillResultCardState createState() => _PillResultCardState();
}

class _PillResultCardState extends State<PillResultCard> {
  List<Drug> drugList = [];
  List<Drug> initialDrugList = [];
  List<dynamic> coordList = [];
  List<dynamic> positionList = [];
  String jsonString;

  List<DrugHistoryItemTime> _todayList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _drugListKey = GlobalKey<DrugListState>();
  final PrescriptionRepository prescriptionRepository =
      serviceLocator<PrescriptionRepository>();
  final _fireStorageInstance = FirebaseStorage.instance;

  bool _isLoading = true;
  String strListDrug = '';
  String missedDrug = '';

  Map<String, dynamic> jsonBody;
  Map<String, dynamic> res;

  String userId;
  // File rotatedImage;

  @override
  initState() {
    super.initState();
    _todayList = this.widget.todayList;
    for (var i = 0; i < _todayList.length; i++) {
      var drugName = _todayList[i].name;

      if (i < _todayList.length - 1) {
        strListDrug += '$drugName|';
      } else {
        strListDrug += '$drugName';
      }
    }

    userId = getUserId();

    getDrugListData();
    // missedDrug = _getMissingDrug();
  }

  Future<void> getDrugListData() async {
    // final rImage =
    //     await FlutterExifRotation.rotateImage(path: widget.imagePath);
    res = await getDrugListResult(File(widget.imagePath), strListDrug, userId);

    setState(() {
      _isLoading = true;
    });
    print('Enter get drug list...');
    print('strListResult: $strListDrug');

    if (res != null) {
      print('Res != null');
      print(res);
      setState(() {
        drugList = res['drugs'] as List<Drug>;
        initialDrugList = res['drugs'] as List<Drug>;
        print(
            'hungvv - first check initialDrugList: ${res['drugs'].toString()}');

        // print('hungvv -final initiallistdrug:');
        // initialListDrug.forEach((drug) {
        //   print('${drug.name}');
        // });
        // rotatedImage = rImage;

        print('hungvv -drugList ${drugList.toString()}');
        coordList = res['boxes'] as List<dynamic>;
        positionList = res['positions'] as List<dynamic>;
        // if (coordList != null)
        //   print('DUYNA: coord list length: ${coordList.length}');
        jsonString = res['jsonString'] as String; // tra ve json string
        jsonBody = json.decode(jsonString);
        print('hungvv -json Body: ${jsonBody.toString()}');
        // print('DUYNA: coord list length: ${coordList.length}');
        _isLoading = false;
        missedDrug = _getMissingDrug();
        // print('hungvv miss drug - $missedDrug');
      });
    } else {
      setState(() {
        drugList = [];
        coordList = null;
        // rotatedImage = rImage;
        if (coordList != null)
          print('DUYNA: coord list length: ${coordList.length}');
        jsonString = ''; // tra ve json string
        _isLoading = false;
        missedDrug = _getMissingDrug();
        print('hungvv miss drug - $missedDrug');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading)
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 5.h),
              AppBar(
                title: Text('Ảnh viên thuốc '),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () =>
                      NavigationService().popAndPushNamed(ROUTER_MAIN),
                ),
              ),
              SizedBox(height: 100.h),
              // Image.file(File(widget.imagePath), width: 100.w, height: 150.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(236, 237, 237, 1),
                  border: Border.all(
                    color: kInputBorderEnableColor,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // _getCropImgs(0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Text(
                          'Xác nhận loại thuốc và số lượng bạn đang uống',
                          style: TextStyle(
                            fontFamily: 'SansFrancisco',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              "Tên thuốc",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "Liều dùng",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "Ảnh thuốc",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Xoá",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      DrugList(
                        key: _drugListKey,
                        listPill: drugList,
                        todayList: _todayList,
                        coordList: coordList,
                        imagePath: widget.imagePath,
                        onPress:
                            reloadData, // khi sua thong tin thuoc thi thong tin thuoc va thong tin update label
                        deleteDrugItem: _deleteDrugItem,
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 100.h),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Align(
                              child: Text(
                                missedDrug,
                                style: TextStyle(color: Colors.red),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              print('hungvv drugList- $drugList');
                              drugList.add(Drug(
                                id: '',
                                amount: 1,
                                doseUnit: '0',
                                timeConsume: TimeConsume.NONE,
                                nDaysPerWeek: 0,
                                nTimesPerDay: 1,
                              ));
                              coordList.add(null);
                              // add thuoc moi vao jsonBody
                            });
                            Future.delayed(
                              Duration(milliseconds: 50),
                              _scrollToBottomOfDrugList,
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                child: Text('+',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SanFrancisco",
                                        fontSize: 20.nsp)),
                                backgroundColor: kPrimaryColor,
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(
                                'Thêm thuốc',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontFamily: 'SansFrancisco',
                                  fontSize: 14.nsp,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 15.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MyIcon(
                                      svgIconPath: 'assets/icons/camera.svg',
                                      color: kPrimaryColor),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text("Chụp lại",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "SanFrancisco",
                                          fontSize: 14.0)),
                                ],
                              ),
                              color: Color.fromRGBO(236, 237, 237, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                      color: kPrimaryColor,
                                      width: 1,
                                      style: BorderStyle.solid)),
                              onPressed: () async {
                                final imgPath = await NavigationService()
                                    .pushNamed(ROUTER_CAPTURE,
                                        arguments: {'isPill': true});
                                if (imgPath != null) {
                                  await getDrugListData();
                                  setState(() {
                                    print('DUYNA: change state!');
                                    this.widget.imagePath = imgPath;
                                  });
                                }
                              }),
                          FlatButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25.w, vertical: 15.h),
                            child: Text("Xác nhận",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SanFrancisco",
                                    fontSize: 14.0)),
                            color: Color.fromRGBO(26, 173, 187, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onPressed: () => _submitData(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    else
      return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                    child: Text(
                        "Hãy đợi vài giây để chúng tôi trích xuất thông tin những thuốc cần uống của bạn..."),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  _getCropImgFilePath(String filePath, var coord) {
    final image = i.decodeImage(File(widget.imagePath).readAsBytesSync());

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

  _saveNewCropImageFirebase() async {
    drugList.asMap().forEach((idx, drug) async {
      final drugId = getDrugIDByName(drug.name);
      final _croppedImageDir = await getFilePath(drugId);

      _getCropImgFilePath(_croppedImageDir, coordList[idx]);
      // print('hungvv cropped img - $croppedImage');
      var pillFirebaseUrl = "images/$userId/$drugId.jpg";
      // print('firebase url drugid: ${this.widget.drugId}');
      // print('firebase url: $pillFirebaseUrl');

      // // check anh thuoc da ton tai chua
      // final imageFirestore =
      //     await DrugDetailScreenLogic().getUrlUpdate(imagePath: pillFirebaseUrl);
      // print('[IMAGE BUTTON] hungvv imageFileStorage - $imageFirestore');
      // print('hungvv pillFirebaseUrl - $pillFirebaseUrl');

      // //neu chua ton tai thi up anh
      // if (imageFirestore == '') {
      print('[IMAGE BUTTON] now upload image');
      await uploadImagePill(
          imagePathFirestore: pillFirebaseUrl, path: _croppedImageDir);
      // }
    });
  }

  _submitData() async {
    print('submit data list...');
    drugList.forEach((drug) {
      final idx =
          _todayList.indexWhere((element) => (element.name == drug.name));
      if (idx != -1) {
        print('Duyna: Update taken ${_todayList[idx].name}');
        _todayList[idx].isTaken = true;
        _todayList[idx].amount = drug.amount;
        _todayList[idx].takenHour = TimeOfDay.now().hour;
        _todayList[idx].takenMinute = TimeOfDay.now().minute;
      } else {
        final out_drug = DrugHistoryItemTime.fromMap({
          'ten_thuoc': drug.name,
          'hour': _todayList[0].hour,
          'minute': _todayList[0].minute,
          'taken_hour': TimeOfDay.now().hour,
          'taken_minute': TimeOfDay.now().minute,
          'taken_date': Timestamp.now(),
          'da_uong': true,
          'anh': '',
          'id': '',
          'lieu_dung': drug.amount
        });
        out_drug.isOutside = true;
        _todayList.add(out_drug);
      }
    });
    await _saveNewCropImageFirebase();
    await prescriptionRepository.updateMedHistoryAtTime(_todayList,
        _todayList[0].hour, _todayList[0].minute, widget.selectedDate, false);

    await updateJsonLabels(jsonBody, userId);
    context.read<ScreenReloadModel>().markHomeScreenAsNeedReloading();
    NavigationService().popUtils(ROUTER_MAIN);
    // NavigationService().pushReplacementNamed(ROUTER_MAIN);
  }

  _deleteDrugItem(List<Drug> drugList, int idx) {
    setState(() {
      drugList.removeAt(idx);
    });
  }

  _getMissingDrug() {
    List<DrugHistoryItemTime> takingTakenDrug = []; // uong thuoc da uong xong
    List<Drug> takingInsufficientDrug = []; // uong thieu thuoc
    List insufficientDrugNumber = [];
    List insufficientDrugDose = [];
    List<Drug> takingExtraDrug = []; // uong thua thuoc
    List extraDrugNumber = [];
    List extraDrugDose = [];
    List<Drug> takingOutsideDrug = []; // uong thuoc ngoai
    List<DrugHistoryItemTime> missingDrug = []; //uong thieu thuoc
    var totalStr = '';
    var status = 1;

    List todayListDrugName = [];
    List takingListDrugName = [];
    _todayList.forEach((drug) {
      todayListDrugName.add(drug.name);
    });

    drugList.forEach((drug) {
      takingListDrugName.add(drug.name);
    });

    _todayList.forEach((drug) {
      // xet cac thuoc phai uong tai gio hien tai
      // neu thuoc da uong tai thoi diem hien tai ma uong nua thi bao uong thua + set status = -1
      if (drug.isTaken) {
        drugList.forEach((takingDrug) {
          if (takingDrug.name == drug.name) {
            takingTakenDrug.add(drug);
            status = -1;
          }
        });
      } else {
        drugList.forEach((takingDrug) {
          if (takingDrug.name == drug.name && takingDrug.amount < drug.amount) {
            takingInsufficientDrug.add(takingDrug);
            insufficientDrugNumber.add(drug.amount - takingDrug.amount);
            insufficientDrugDose.add(takingDrug.doseUnit);
            status = 1;
          } else if (takingDrug.name == drug.name &&
              takingDrug.amount > drug.amount) {
            takingExtraDrug.add(takingDrug);
            extraDrugNumber.add(takingDrug.amount - drug.amount);
            extraDrugDose.add(takingDrug.doseUnit);
            status = 1;
          }
        });
      }
    });

    drugList.forEach((takingDrug) {
      if (!todayListDrugName.contains(takingDrug.name)) {
        takingOutsideDrug.add(takingDrug);
        status = -1;
      }
    });

    _todayList.forEach((drug) {
      if (!takingListDrugName.contains(drug.name)) {
        missingDrug.add(drug);
        status = -1;
      }
    });

    print('hungvv - missing drug');
    print(status);
    print('takingTakenDrug - ${takingTakenDrug.toString()}');
    print('takingInsufficientDrug - ${takingInsufficientDrug.toString()}');
    print('takingExtraDrug - ${takingExtraDrug.toString()}');
    print('takingOutsideDrug - ${takingOutsideDrug.toString()}');
    print('missingDrug - ${missingDrug.toString()}');

    if (takingTakenDrug.length > 0) {
      takingTakenDrug.forEach((drug) {
        totalStr +=
            '\nBạn đã uống thuốc ${drug.name} vào lúc ${drug.takenDate.hour}:${drug.takenDate.minute} ${drug.takenDate.day}-${drug.takenDate.month}-${drug.takenDate.year}\n';
      });
    }

    if (takingInsufficientDrug.length > 0) {
      for (int i = 0; i < takingInsufficientDrug.length; i++) {
        totalStr +=
            '\nBạn đang uống thiếu ${takingInsufficientDrug[i].name} (${insufficientDrugNumber[i]} ${numberToUnit[insufficientDrugDose[i]]})\n';
      }
    }

    if (takingExtraDrug.length > 0) {
      for (int i = 0; i < takingExtraDrug.length; i++) {
        totalStr +=
            '\nBạn đang uống thừa ${takingExtraDrug[i].name} (${extraDrugNumber[i]} ${numberToUnit[extraDrugDose[i]]})\n';
      }
    }

    if (takingOutsideDrug.length > 0) {
      for (int i = 0; i < takingOutsideDrug.length; i++) {
        totalStr +=
            '\nBạn đang uống ${takingOutsideDrug[i].name} không có trong đơn thuốc\n';
      }
    }

    if (missingDrug.length > 0) {
      for (int i = 0; i < missingDrug.length; i++) {
        totalStr +=
            '\nBạn chưa uống ${missingDrug[i].name} có trong đơn thuốc\n';
      }
    }

    if (status == 1) {
      totalStr = '\nBạn đã uống đúng thuốc cho lần này\n';
    }
    return totalStr;
  }

  _updateJsonBody() {
    // update jsonBody
    // co drugList cu, co initialDrugList
    // tim xem voi moi thuoc trong  drugList, thuoc tuong ung trong initialDrugList co doi khong
    // neu doi thi tim index cua thuoc tuong ung trong positionList va sua ten thuoc tuong ung voi index trong jsonBody

    print('drugList ${drugList.toString()}');
    print('initialDrugList ${initialDrugList.toString()}');
    for (var i = 0; i < initialDrugList.length; i++) {
      if (initialDrugList[i].name != drugList[i].name) {
        print('hungvv- altered drug name');
        print(initialDrugList[i].name);
        print(drugList[i].name);
        for (var j = 0; j < positionList[i].length; j++)
        // neu phat hien co ten thuoc bi doi
        {
          jsonBody['result']['pills'][j]['pillname'] = drugList[i].name;
          // if (jsonBody['result']['pills'][j]['pillname'] ==
          //         initialDrugList[i].name &&
          //     initialDrugList[i].name != drugList[i].name) {
          //   jsonBody['result']['pills'][j] = drugList[i].name;
          // }
        }
      }
    }
    print('hungvv - json Body altered ${jsonBody.toString()}');
    return jsonBody;
  }

  reloadData() {
    print('reload missing drug clicked');
    setState(() {
      missedDrug = _getMissingDrug();

      jsonBody = _updateJsonBody();
      print('reload missing drug clicked phan 2');
    });
  }

  _scrollToBottomOfDrugList() {
    _drugListKey.currentState.scrollToBottom();
  }
}
