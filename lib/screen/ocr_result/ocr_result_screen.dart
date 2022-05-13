import 'dart:io';
import 'package:emed/components/generic_snackbar.dart';
import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/provider/model/prescription_model.dart';
import 'package:emed/screen/picture_display/picture_display_screen.dart';
import 'package:emed/shared/api/drug_api.dart';
import 'package:emed/shared/api/ocr_api.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:emed/shared/widget/my_icon.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'components/custom_text_field.dart';
import 'components/custom_text_form_field.dart';
import 'components/drug_list.dart';
import 'components/text_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emed/shared/setting/constant.dart';

class OcrResultScreen extends StatefulWidget {
  final String image_path;
  String symptomText;
  String diagnoseText;

  OcrResultScreen({
    Key key,
    this.image_path,
  }) : super(key: key);

  @override
  _OcrResultScreenState createState() => _OcrResultScreenState();
}

class _OcrResultScreenState extends State<OcrResultScreen> {
  final _formKey = GlobalKey<FormState>();
  Prescription _prescription;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _drugListKey = GlobalKey<DrugListState>();

  @override
  initState() {
    super.initState();
    getPrescriptionData();
  }

  void getPrescriptionData() async {
    await getPrescriptionInformation(File(widget.image_path)).then((result) {
      print('hungvv');
      print('hungvv: ahihi $result');
      if (result != null) {
        setState(() {
          _prescription = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrescriptionModel>(
      builder: (BuildContext ctx, model, Widget child) {
        if (_prescription != null) {
          // _prescription = model.prescription;
          _prescription.local_image_url = widget.image_path;

          return Scaffold(
            key: _scaffoldKey,
            body: SafeArea(
              child: Column(children: [
                SizedBox(height: 5.h),
                IconBar(),
                SizedBox(height: 5.h),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DisplayPictureScreen(
                                              imagePath: widget.image_path,
                                              isPill: false)));
                            },
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: SizedBox(
                                  width: 350.w,
                                  height: 190.w,
                                  child: Image.file(File(widget.image_path))),
                            ),
                          ),
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextField(textContent: "Triệu chứng"),
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.fromLTRB(
                                        24.w, 5.w, 24.w, 5.w),
                                    child: CustomTextFormField(
                                      initialText: _prescription?.symptom ?? '',
                                      isFullRowTextField: true,
                                      isEnabled: false,
                                      // onChanged: (value) {
                                      //   setState(() {
                                      //     _prescription.symptom = value;
                                      //   });
                                      // },
                                      onTapped: () {
                                        _displayTextDialogSymptom(
                                            _prescription);
                                      },
                                    ),
                                  ),
                                  CustomTextField(textContent: "Chẩn đoán"),
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.fromLTRB(
                                        24.w, 5.w, 24.w, 5.w),
                                    child: CustomTextFormField(
                                      initialText:
                                          _prescription?.diagnose ?? '',
                                      isFullRowTextField: true,
                                      isEnabled: false,
                                      // onChanged: _displayTextDialog,
                                      onTapped: () {
                                        _displayTextDialogDiagnose(
                                            _prescription);
                                      },
                                    ),
                                  ),
                                  CustomTextField(textContent: "Đơn thuốc"),
                                  TextBar(),
                                  Expanded(
                                    child: DrugList(
                                      key: _drugListKey,
                                      prescription: _prescription,
                                      deleteDrugItem: _deleteDrugItem,
                                    ),
                                  ),
                                  SizedBox(height: 10.w),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildBackButton(),
                    ],
                  ),
                ),
                // SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _prescription.listPill.add(Drug(
                          id: '',
                          amount: 1,
                          doseUnit: '2',
                          timeConsume: TimeConsume.NONE,
                          nDaysPerWeek: 0,
                          nTimesPerDay: 1,
                        ));
                      });
                      Future.delayed(
                        Duration(milliseconds: 50),
                        _scrollToBottomOfDrugList,
                      );
                    },
                    child: MyIcon(svgIconPath: 'assets/icons/add_button.svg'),
                  ),
                )
              ]),
            ),
            bottomNavigationBar: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5.w),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 125.w,
                    child: OutlineButton(
                      onPressed: () {
                        NavigationService()
                            .pushReplacementNamed(ROUTER_CAPTURE);
                      },
                      child: Text(
                        "Chụp lại",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1.w,
                        style: BorderStyle.solid,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 13.w,
                  ),
                  SizedBox(
                    width: 125.w,
                    child: FlatButton(
                      onPressed: () {
                        if (_prescription.listPill.length == 0) {
                          GlobalSnackBar.show(_scaffoldKey, context,
                              'Hãy thử chụp lại đơn thuốc');
                        }
                        // them validator
                        if (_formKey.currentState.validate()) {
                          GlobalSnackBar.show(_scaffoldKey, context,
                              'Hãy điền đầy đủ các trường và thử lại ');
                        }

                        // check neu khong dien thong tin ve trieu chung va chan doan thi pop canh bao
                        if (_prescription.diagnose == '' ||
                            _prescription.symptom == '' ||
                            checkPrescriptionPillNameIsEmpty(_prescription)) {
                          GlobalSnackBar.show(_scaffoldKey, context,
                              'Hãy điền đầy đủ các trường và thử lại');
                        }
                        // check neu khong boc tach duoc thong tin thi pop canh bao
                        else {
                          setState(() {
                            _prescription.listPill
                                .asMap()
                                .forEach((idx, val) async {
                              final drugMatched = await getDrugByNameIfMatch(
                                  _prescription.listPill[idx].name);

                              _prescription.listPill[idx].id =
                                  drugMatched?.length == 0
                                      ? genDrugID(
                                          drugName:
                                              _prescription.listPill[idx].name)
                                      : drugMatched[0]['soDangKy'];
                              print('hungvv -drugid');
                              print(_prescription.listPill[idx].id);
                              print('cuong -imageLocalPath');

                              print(_prescription.listPill[idx].localImagePath);
                            });

                            // cho navigation o trong setstate de thay doi xong moi change path
                            NavigationService().pushNamed(ROUTER_SCHEDULE,
                                arguments: {"prescription": _prescription});
                          });
                        }
                      },
                      child: Text(
                        "Lưu",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.w, vertical: 15.h),
                        child: Text(
                            "Hãy đợi vài giây để chúng tôi trích xuất thông tin từ đơn thuốc của bạn..."),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
      },
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 8, 8, 8),
        child: Icon(Icons.arrow_back_ios),
      ),
    );
  }

  _displayTextDialogSymptom(Prescription _prescription) async {
    var tmpSymptom = '';
    await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Triệu chứng',
                ),
                initialValue: _prescription?.symptom ?? '',
                onChanged: (value) {
                  print('hugnvv - changed value');
                  print(value == null);
                  if (value != null) tmpSymptom = value;
                },
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Lưu'),
              onPressed: () {
                setState(() {
                  // print('hungvv - tmpSymptom');
                  // print(tmpSymptom);
                  if (tmpSymptom != '') _prescription.symptom = tmpSymptom;

                  // print(_prescription.symptom);
                });
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Huỷ'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  _displayTextDialogDiagnose(Prescription _prescription) async {
    var tmpDiagnose = '';
    await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: TextFormField(
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Chẩn đoán',
                ),
                initialValue: _prescription?.diagnose ?? '',
                onChanged: (value) {
                  tmpDiagnose = value;
                },
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Lưu'),
              onPressed: () {
                setState(() {
                  // print(tmpDiagnose);
                  if (tmpDiagnose != '') _prescription.diagnose = tmpDiagnose;
                  // print(_prescription.diagnose);
                });
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Huỷ'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  bool checkPrescriptionPillNameIsEmpty(Prescription pres) {
    for (var pill in pres.listPill) {
      print('hungvv-test pill name 1:  ${pill.name}');
      if (pill.name == null || pill.name == '') {
        print('hungvv-test pill name 2: ${pill.name}');
        return true;
      }
    }
    return false;
  }

  _deleteDrugItem(Prescription _prescription, int idx) {
    setState(() {
      _prescription.listPill.removeAt(idx);
    });
  }

  _scrollToBottomOfDrugList() {
    _drugListKey.currentState.scrollToBottom();
  }
}
