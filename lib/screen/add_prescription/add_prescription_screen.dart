import 'dart:io';

import 'package:emed/components/generic_snackbar.dart';
import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/model/show_case_setting.dart';
import 'package:emed/shared/api/drug_api.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:emed/shared/widget/my_icon.dart';
import 'package:flutter/material.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'components/custom_text_field.dart';
import 'components/custom_text_form_field.dart';
import 'components/drug_list.dart';
import 'components/text_bar.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPrescriptionScreen extends StatefulWidget {
  AddPrescriptionScreen({Key key}) : super(key: key);

  @override
  _AddPrescriptionScreenState createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _drugListKey = GlobalKey<DrugListState>();
  Prescription _prescription;

  // Global keys for show cases
  final _captureBtn = GlobalKey();
  final _addBtn = GlobalKey();
  final _columnKey = GlobalKey();

  @override
  initState() {
    super.initState();
    _prescription = Prescription(
        id: '',
        image_url: '',
        local_image_url: '',
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
        nDaysPerWeek: 0,
        listPill: []);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showTutorial();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    Padding(
                      padding: EdgeInsets.only(top: 40.h),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                key: _captureBtn,
                                onTap: () => NavigationService()
                                    .pushNamed(ROUTER_CAPTURE),
                                child: Container(
                                  width: 95.w,
                                  height: 95.w,
                                  margin: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: kBorderPrimaryColor),
                                      color: kPrimaryBackgroundColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 5.h),
                                    child: MyIcon(
                                      svgIconPath: 'assets/icons/camera.svg',
                                      color: Color.fromRGBO(115, 115, 115, 1),
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SizedBox(
                              width: 250.w,
                              child: Padding(
                                padding: EdgeInsets.all(5.w),
                                child: Text(
                                  'Nhấp chụp để tự động đọc thông tin từ đơn thuốc, hoặc điền các thông tin bên dưới',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          key: _columnKey,
                          children: [
                            CustomTextField(textContent: "Triệu chứng"),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.topLeft,
                              padding:
                                  EdgeInsets.fromLTRB(24.w, 5.w, 24.w, 5.w),
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
                                  _displayTextDialogSymptom(_prescription);
                                },
                              ),
                            ),
                            CustomTextField(textContent: "Chẩn đoán"),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.topLeft,
                              padding:
                                  EdgeInsets.fromLTRB(24.w, 5.w, 24.w, 5.w),
                              child: CustomTextFormField(
                                initialText: _prescription?.diagnose ?? '',
                                isFullRowTextField: true,
                                isEnabled: false,
                                // onChanged: _displayTextDialog,
                                onTapped: () {
                                  _displayTextDialogDiagnose(_prescription);
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
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              key: _addBtn,
              onTap: () {
                setState(() {
                  _prescription.listPill.add(Drug(
                    id: '',
                    name: '',
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
              width: 250.w,
              child: FlatButton(
                onPressed: () {
                  if (_prescription.listPill.length == 0) {
                    GlobalSnackBar.show(
                        _scaffoldKey, context, 'Hãy thử chụp lại đơn thuốc');
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
                      _prescription.listPill.asMap().forEach((idx, val) async {
                        final drugMatched = await getDrugByNameIfMatch(
                            _prescription.listPill[idx].name);

                        _prescription.listPill[idx].id =
                            drugMatched?.length == 0
                                ? genDrugID(
                                    drugName: _prescription.listPill[idx].name)
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

  _deleteDrugItem(Prescription _prescription, int idx) {
    setState(() {
      _prescription.listPill.removeAt(idx);
    });
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

  _scrollToBottomOfDrugList() {
    _drugListKey.currentState.scrollToBottom();
  }

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];

  void initTargets() {
    // targets.add(
    //   buildTarget(
    //     keyTarget: _columnKey,
    //     description: 'Chi tiết nội dung đơn thuốc',
    //     enableOverlayTab: true,
    //     enableTargetTab: false,
    //     contentAlign: ContentAlign.top,
    //     shape: ShapeLightFocus.RRect,
    //   ),
    // );
    targets.add(
      buildTarget(
        keyTarget: _captureBtn,
        description: 'Nhấp để tự động đọc thông tin từ đơn',
        enableOverlayTab: true,
        enableTargetTab: false,
        contentAlign: ContentAlign.bottom,
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      buildTarget(
        keyTarget: _addBtn,
        description: 'Hoặc nhấp để thêm thuốc thủ công',
        enableOverlayTab: true,
        enableTargetTab: false,
      ),
    );
  }

  void showTutorial() {
    if (!ShowCaseSetting.instance.addPrescriptionScreen) {
      return;
    }
    sleep(Duration(milliseconds: 200));
    initTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      textSkip: "Bỏ qua",
      paddingFocus: 0,
      focusAnimationDuration: Duration(milliseconds: 300),
      pulseAnimationDuration: Duration(milliseconds: 500),
      onClickOverlay: (_) {
        tutorial.next();
      },
      onFinish: completeShowCases,
      onSkip: completeShowCases,
    )..show();
  }

  completeShowCases() {
    ShowCaseSetting.instance.updateWith({
      ShowCaseSettingKey.addPrescriptionScreen: false,
    });
  }
}
