import 'dart:io';

import 'package:emed/components/custom_week_calendar.dart';
import 'package:emed/data/model/drug_time.dart';
import 'package:emed/data/model/show_case_setting.dart';
import 'package:emed/screen/ocr_result/components/custom_text_form_field.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:emed/shared/extension/date.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:emed/data/model/drug.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  ScheduleScreenState createState() => ScheduleScreenState();
  final Drug medicine;
  final int index;
  final int prescriptionsLength;
  final Function(Drug) applyToAll;
  ScheduleScreen(
      {Key key,
      this.medicine,
      this.index,
      this.prescriptionsLength,
      this.applyToAll})
      : super(key: key);
}

class ScheduleScreenState extends State<ScheduleScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<String> _frequencyOpt = [
    'Một số ngày trong tuần',
    'Mọi ngày trong tuần'
  ];
  final _numberOfPillController = TextEditingController();
  //set default value
  Map<String, bool> _drugDay = {
    'T2': false,
    'T3': false,
    'T4': false,
    'T5': false,
    'T6': false,
    'T7': false,
    'CN': false
  };

  Drug get medicine => widget.medicine;
  Function get applyToAll => widget.applyToAll;

  DateTime get _beginDate => medicine.startedAt;
  set _beginDate(DateTime date) => medicine.startedAt = date;
  DateTime get _endDate => medicine.completedAt;
  set _endDate(DateTime date) => medicine.completedAt = date;

  int get _numberOfPill => medicine.amount;
  set _numberOfPill(int n) => medicine.amount = n;
  bool _isEnable = true;

  // global keys for showcase
  GlobalKey _columnKey2 = GlobalKey();
  GlobalKey _startDateKey = GlobalKey();
  GlobalKey _endDateKey = GlobalKey();
  GlobalKey _daysOfWeekKey = GlobalKey();
  GlobalKey _timeKey = GlobalKey();
  GlobalKey _pillCountKey = GlobalKey();

  @override
  void initState() {
    if (medicine.drugTimeList.isEmpty) {
      medicine.drugTimeList.addAll(List.generate(
          medicine.nTimesPerDay, (index) => DrugTime(hour: 8, minute: 0)));
    }
    // _frequency = medicine.dayOfWeekList.length == 7
    //     ? _frequencyOpt[1]
    //     : _frequencyOpt[0];
    print(medicine.dayOfWeekList.toString());
    medicine.dayOfWeekList.forEach((day) {
      switch (day) {
        case 1:
          _drugDay['T2'] = true;
          break;
        case 2:
          _drugDay['T3'] = true;
          break;
        case 3:
          _drugDay['T4'] = true;
          break;
        case 4:
          _drugDay['T5'] = true;
          break;
        case 5:
          _drugDay['T6'] = true;
          break;
        case 6:
          _drugDay['T7'] = true;
          break;
        case 7:
          _drugDay['CN'] = true;
          break;
        default:
      }
    });
    // widget.medicine.drugDays = _drugDay;
    // print('hungvv - schedule drug id');
    // print(widget.medicine.id);
    if (medicine.dayOfWeekList.length == 7)
      _isEnable = false;
    else
      _isEnable = true;

    _numberOfPillController.text = _numberOfPill.toString();
    _numberOfPillController.addListener(() {
      if (_numberOfPillController.text != '')
        _numberOfPill = int.parse(_numberOfPillController.text);
      else
        _numberOfPill = 1;
      print('Number of pill: ' + _numberOfPill.toString());
    });
    super.initState();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    showTutorial();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        key: _columnKey2,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(txtContent: "Tên thuốc"),
                CustomTextFormField(
                  initialText:
                      widget.medicine != null ? widget.medicine.name : "",
                  isFullRowTextField: true,
                  isEnabled: false,
                  // onChanged: () {},
                  onTapped: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(txtContent: "Bạn dùng thuốc trong bao lâu?"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bắt đầu",
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kTextNoteColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 12.sp)),
                        SizedBox(
                          height: 10.w,
                        ),
                        OutlineButton(
                          key: _startDateKey,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.w),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () => _showDateTime(true),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/icons/date_inactive.png'),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  _beginDate?.formatDate(format: 'E,MM/dd') ??
                                      '',
                                  style: TextStyle(
                                      color: Color.fromRGBO(12, 24, 39, 1),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "SanFrancisco",
                                      fontSize: 12.sp),
                                )
                              ],
                            ),
                          ),
                          borderSide:
                              BorderSide(color: kInputBorderEnableColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kết thúc",
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kTextNoteColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 12.sp)),
                        SizedBox(
                          height: 10.w,
                        ),
                        OutlineButton(
                          key: _endDateKey,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.w),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () => _showDateTime(false),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/icons/date_inactive.png'),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  _endDate?.formatDate(format: 'E,MM/dd') ?? '',
                                  style: TextStyle(
                                      color: Color.fromRGBO(12, 24, 39, 1),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "SanFrancisco",
                                      fontSize: 12.sp),
                                )
                              ],
                            ),
                          ),
                          borderSide:
                              BorderSide(color: kInputBorderEnableColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Column(
            key: _daysOfWeekKey,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                        txtContent: "Bạn dùng thuốc bao lâu một lần?"),
                    Container(
                      width: double.infinity,
                      height: 37.w,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kInputBorderEnableColor,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(1.w),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                              isExpanded: true,
                              //set default value dua vao so ngay uong thuoc trong tuan
                              value: medicine.dayOfWeekList.length == 7
                                  ? _frequencyOpt[1]
                                  : _frequencyOpt[0],
                              elevation: 1,
                              icon: ImageIcon(
                                  AssetImage('assets/icons/dropdown.png')),
                              iconSize: 30.w,
                              underline: SizedBox(height: 5.w),
                              onChanged: (String newValue) {
                                setState(() {
                                  // _frequency = newValue;
                                  // can lay cac gia tri trong list item o day
                                  if (newValue == _frequencyOpt[0]) {
                                    _drugDay.forEach((key, value) {
                                      _drugDay[key] = false;
                                    });
                                    medicine.nDaysPerWeek = 0;
                                    _isEnable = true;
                                  } else if (newValue ==
                                      _frequencyOpt[1]) // neu chon moi ngay
                                  {
                                    _drugDay.forEach((key, value) {
                                      _drugDay[key] = true;
                                    });
                                    medicine.nDaysPerWeek =
                                        7; //set nDaysPerWeek = 7
                                    _isEnable = false;
                                  }
                                  medicine.drugDays = _drugDay;
                                });

                                medicine.dayOfWeekList =
                                    []; // index nhung ngay uong thuoc
                                _drugDay.forEach((key, value) {
                                  if (value) {
                                    medicine.dayOfWeekList
                                        .add(getDayOfWeekIndex(key));
                                  }
                                });
                              },
                              items: _frequencyOpt
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: TextStyle(
                                          color: Color.fromRGBO(12, 24, 39, 1),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "SanFrancisco",
                                          fontSize: 12.sp)),
                                );
                              }).toList()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.w),
                child:
                    CustomWeekCalendar(medicine.drugDays, true, _changeDrugDay),
              )
            ],
          ),
          SizedBox(
            height: 3.w,
          ),
          InkWell(
            onTap: () => applyToAll(medicine),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 5.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kPrimaryExtraLightColor,
                  border: Border.all(
                    color: kPrimaryColor,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Text('Áp dụng lịch uống cho toàn bộ đơn thuốc',
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "SanFrancisco",
                        fontSize: 12.sp)),
              ),
            ),
          ),
          // SizedBox(
          //   height: 15.h,
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 30.w),
          //   child: Container(
          //     height: 1.w,
          //     color: kSeparator,
          //   ),
          // ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 5.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bạn hãy đặt giờ uống thuốc.',
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(12, 24, 39, 1),
                            fontWeight: FontWeight.w500,
                            fontFamily: "SanFrancisco",
                            fontSize: 12.sp)),
                    SizedBox(
                      height: 10.w,
                    ),
                    ListView.builder(
                        key: _timeKey,
                        itemCount: medicine.nTimesPerDay,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, idx) {
                          return Container(
                            height: 55.h,
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: InkWell(
                              onTap: () => _showTimePicker(idx),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 10.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: kPrimaryExtraLightColor,
                                    borderRadius: BorderRadius.circular(5.w),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/icons/clock.png'),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                              medicine.drugTimeList[idx]
                                                  .formatTime(),
                                              // textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      162, 168, 191, 1),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "SanFrancisco",
                                                  fontSize: 12.sp)),
                                        ],
                                      ),
                                      // SizedBox(
                                      //   width: 10.w,
                                      // ),
                                      Image.asset('assets/icons/edit.png')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                  ])),
          SizedBox(
            height: 10.w,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bạn uống bao nhiêu viên 1 lần?',
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(12, 24, 39, 1),
                        fontWeight: FontWeight.w500,
                        fontFamily: "SanFrancisco",
                        fontSize: 12.sp)),
                SizedBox(
                  height: 10.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => _removeDrug(),
                      child: Container(
                          height: 37.w,
                          width: 37.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 7.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: _numberOfPill > 1
                                  ? kPrimaryColor
                                  : kInputBorderEnableColor,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Text('-',
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: _numberOfPill > 1
                                      ? kPrimaryColor
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "SanFrancisco",
                                  fontSize: 12.sp))),
                    ),
                    Container(
                        key: _pillCountKey,
                        height: 37.w,
                        width: 150.w,
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: 20.w, vertical: 7.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: kInputBorderEnableColor,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child:
                            // Text(_numberOfPill.toString(),
                            //     // textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontWeight: FontWeight.w500,
                            //         fontFamily: "SanFrancisco",
                            //         fontSize: 12.sp))),
                            TextField(
                                controller: _numberOfPillController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15.w,
                                      bottom: 18.h,
                                      top: 10.h,
                                      right: 15.w),
                                ),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SanFrancisco",
                                    fontSize: 12.sp))),
                    InkWell(
                      onTap: () => _addDrug(),
                      child: Container(
                          height: 37.w,
                          width: 37.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 7.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: kPrimaryColor,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Text('+',
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "SanFrancisco",
                                  fontSize: 12.sp))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  /// index start from 1 (Monday) to 7 (Sunday)
  int getDayOfWeekIndex(String day) {
    switch (day) {
      case 'T2':
        return 1;
      case 'T3':
        return 2;
      case 'T4':
        return 3;
      case 'T5':
        return 4;
      case 'T6':
        return 5;
      case 'T7':
        return 6;
      case 'CN':
        return 7;
    }
  }

  void _showDateTime(bool begin) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        if (begin)
          setState(() {
            _beginDate = date;
            if (_beginDate.isAfter(_endDate)) {
              _endDate = date;
            }
          });
        else
          setState(() {
            _endDate = date;
          });
      },
      // currentTime: DateTime.now(),
      minTime: begin ? DateTime.now() : _beginDate,
      locale: LocaleType.vi,
    );
  }

  void _changeDrugDay(Map<String, bool> updated) {
    setState(() {
      _drugDay = updated;
      medicine.drugDays = updated;
      medicine.dayOfWeekList = [];
      updated.forEach((key, value) {
        if (value) {
          final exists = medicine.dayOfWeekList.indexOf(getDayOfWeekIndex(key));
          if (exists == -1) medicine.dayOfWeekList.add(getDayOfWeekIndex(key));
        }
      });
    });

    print(
        'Phungtd: Update days of week, size: ${medicine.dayOfWeekList.length} days: ${medicine.dayOfWeekList}');
  }

  void _showTimePicker(int index, {DateTime currentTime}) {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        setState(() {
          // _drugTime[index] = time.formatDate(format: 'Hm');
          medicine.drugTimeList[index] =
              DrugTime(hour: time.hour, minute: time.minute);
        });
      },
      currentTime: currentTime ?? DateTime.now(),
      locale: LocaleType.vi,
      showSecondsColumn: false,
    );
  }

  void _addDrug() {
    setState(() {
      _numberOfPill += 1;
      _numberOfPillController.text = _numberOfPill.toString();
    });
  }

  void _removeDrug() {
    if (_numberOfPill > 1)
      setState(() {
        _numberOfPill -= 1;
        _numberOfPillController.text = _numberOfPill.toString();
      });
  }

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];

  void initTargets() {
    // targets.add(
    //   buildTarget(
    //     keyTarget: _columnKey2,
    //     description: 'Nhập lịch uống thuốc',
    //     enableOverlayTab: true,
    //     enableTargetTab: false,
    //     contentAlign: ContentAlign.bottom,
    //     shape: ShapeLightFocus.RRect,
    //   ),
    // );
    targets.add(
      buildTarget(
        keyTarget: _startDateKey,
        description: 'Nhấp để chọn ngày bắt đầu uống thuốc',
        enableOverlayTab: true,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      buildTarget(
        keyTarget: _endDateKey,
        description: 'Nhấp để chọn ngày kết thúc uống thuốc',
        enableOverlayTab: true,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      buildTarget(
        keyTarget: _daysOfWeekKey,
        description: 'Chọn ngày uống thuốc trong tuần',
        enableOverlayTab: true,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      buildTarget(
        keyTarget: _timeKey,
        description: 'Đặt giờ uống thuốc tại đây',
        enableOverlayTab: true,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      buildTarget(
        keyTarget: _pillCountKey,
        description: 'Điều chỉnh số lượng thuốc mỗi lần tại đây',
        enableOverlayTab: true,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );
  }

  void showTutorial() {
    if (!ShowCaseSetting.instance.scheduleScreen) {
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
      ShowCaseSettingKey.scheduleScreen: false,
    });
  }
}

class CustomTextField extends StatelessWidget {
  final String txtContent;

  const CustomTextField({
    Key key,
    this.txtContent,
  }) : super(key: key);
// "Tên thuốc"
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Text(txtContent,
          // textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromRGBO(12, 24, 39, 1),
              fontWeight: FontWeight.w500,
              fontFamily: "SanFrancisco",
              fontSize: 14.sp)),
    );
  }
}
