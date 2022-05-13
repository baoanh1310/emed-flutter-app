import 'dart:io';

import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/drug_history_item_time.dart';
import 'package:emed/data/repository/notification_repository.dart';
import 'package:emed/data/repository/prescription_repository.dart';
import 'package:emed/data/service_locator.dart';
import 'package:emed/provider/model/screen_reload_model.dart';
import 'package:emed/screen/picture_display/picture_display_screen.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:emed/data/model/show_case_setting.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class NotificationScreen extends StatefulWidget {
  final String notificationPayload;
  final int hour;
  final int minute;
  final DateTime day;

  NotificationScreen({
    Key key,
    this.hour,
    this.minute,
    this.day,
    this.notificationPayload,
  }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final PrescriptionRepository prescriptionRepository =
      serviceLocator<PrescriptionRepository>();
  final notificationRepository = serviceLocator<NotificationRepository>();
  List<DrugHistoryItemTime> result = [];
  String imageUrl;
  List<bool> isChecked = [];

  List<DrugHistoryItemTime> checkedResult = [];

  // Global keys for show cases
  final _checkDrug = GlobalKey();
  final _checkFinishAll = GlobalKey();
  final _checkCaptureDrugBtn = GlobalKey();

  void initState() {
    print('hungvv- ${widget.hour}, ${widget.minute}');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getMedHistoryAtTime(widget.hour, widget.minute, widget.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 295.w,
              // height: 370.h,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        _formatHour(widget.hour, widget.minute),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "SanFrancisco",
                            fontSize: 35.nsp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'Sau khi ăn',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "SanFrancisco",
                            fontSize: 16.nsp),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey.shade100),
                      height: 180.h,
                      child: Scrollbar(
                        child: _buildListView(),
                      ),
                    ),
                    _buildActions(),
                    InkWell(
                      key: _checkCaptureDrugBtn,
                      onTap: () => _navigateToCamera(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child:
                                    Text('Hoặc chụp ảnh các thuốc bạn uống')),
                            SizedBox(width: 8.w),
                            SvgPicture.asset('assets/icons/camera.svg'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildListView() {
    // print('bool notiScreen: ${ShowCaseSetting.instance.notiScreen}');
    if (result.length > 0) {
      showTutorial();
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: result.length,
      // shrinkWrap: true,
      itemBuilder: (_, idx) {
        return Padding(
          // neu la phan tu dau tien thi se hien showcase
          key: idx == 0 ? _checkDrug : null,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: CheckboxListTile(
            value: isChecked[idx],
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: (bool value) {
              setState(() {
                isChecked[idx] = value;
                if (value) {
                  result[idx].isTaken = true;
                  checkedResult.add(result[idx]);
                  print('hungvv - $checkedResult');
                } else {
                  // checkedResult.remove(result[idx]);
                  result[idx].isTaken = false;
                  checkedResult.add(result[idx]);
                  print('hungvv - $checkedResult');
                }
                print('hungvv - checkedResult $checkedResult');
              });
            },
            title: Text(
              '${result[idx].name}',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: "SanFrancisco",
                  fontSize: 18.nsp),
            ),
            subtitle: Text('${result[idx].amount} ${numberToUnit['2']}'),
          ),
        );
      },
    );
  }

  /// actions contain hasTaken / remind after 15m
  Widget _buildActions() {
    bool hasRemindLater = widget.notificationPayload != null;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
      child: Row(
        mainAxisAlignment: hasRemindLater
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 4,
            child: InkWell(
              key: _checkFinishAll,
              onTap: () => _hasTaken(result, checkedResult, widget.hour,
                  widget.minute, widget.day),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/da_uong.svg', height: 18),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      'Đã uống',
                      style: TextStyle(
                        color: Color(0xFF1ABF8E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasRemindLater)
            Flexible(
              flex: 6,
              child: InkWell(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset('assets/icons/nhac_lai.svg', height: 18),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        'Nhắc lại sau 15 phút',
                        style: TextStyle(
                          color: Color(0xFFFF8980),
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: _remindLater,
              ),
            ),
        ],
      ),
    );
  }

  _hasTaken(
    List<DrugHistoryItemTime> originalLstDrugTime,
    List<DrugHistoryItemTime> lstDrugTime,
    int selectedHour,
    int selectedMinute,
    DateTime selectedDate,
  ) async {
    print('hungvv gio uong thuoc- ${selectedHour}');
    print('hungvv phut uong thuoc- ${selectedMinute}');
    print('hungvv ngay uong thuoc- ${selectedDate}');
    print('hungvv ngay uong thuoc- ${lstDrugTime}');

    // update med history
    try {
      await prescriptionRepository.updateMedHistoryAtTime(
          lstDrugTime, selectedHour, selectedMinute, selectedDate, true);
    } catch (e) {
      print(e);
    }

    // home
    context.read<ScreenReloadModel>().markHomeScreenAsNeedReloading();
    NavigationService().popUtils(ROUTER_MAIN);
  }

  _remindLater() {
    if (widget.notificationPayload == null) {
      return;
    }
    final newId = generateRandomInt();
    final oldPayload = NotificationPayload.fromJson(widget.notificationPayload);
    final oldNotiDetail = NotificationDetail(
        id: oldPayload.notiId, payload: widget.notificationPayload, time: null);
    notificationRepository.remindLater(
        oldNoti: oldNotiDetail, newId: newId, minute: 1);
    NavigationService().popUtils(ROUTER_MAIN);
  }

  _navigateToCamera() async {
    if (imageUrl == null || imageUrl == '') {
      final imagePath = await NavigationService()
          .pushNamed(ROUTER_CAPTURE, arguments: {'isPill': true});

      if (imagePath != null && imagePath != '') {
        setState(() {
          imageUrl = imagePath;
        });
      } else {
        setState(() {
          imageUrl = '';
        });
      }
    } else {
      final imagePath = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DisplayPictureScreen(imagePath: imageUrl, isPill: true)));
      //DetectPillOCR(imagePath: imageUrl, isPill: true)));

      if (imagePath != null && imagePath != '') {
        setState(() {
          imageUrl = imagePath;
          print('In anh: ${this.imageUrl}');
        });
      } else {
        setState(() {
          imageUrl = '';
        });
      }
    }
    print(' hungvv  - $imageUrl');
    if (imageUrl != '')
      NavigationService()
          .pushReplacementNamed(PILL_OCR_RESULT_SCREEN, arguments: {
        'imageUrl': this.imageUrl,
        'pillList': this.result,
        'selectedDate': widget.day,
      });
    else
      NavigationService().pop();
  }

  void _getMedHistoryAtTime(
      int selectedHour, int selectedMinute, DateTime selectedDate) async {
    print('hungvv gio uong thuoc- ${selectedHour}');
    print('hungvv phut uong thuoc- ${selectedMinute}');
    print('hungvv ngay uong thuoc- ${selectedDate}');
    try {
      final medicineHistory = await prescriptionRepository.getMedHistoryAtTime(
          selectedHour, selectedMinute, selectedDate);
      // final listUserNote = await prescriptionRepository.getUserQuestionNotify();
      setState(() {
        result = medicineHistory;
        // print('hungvv list result- ${result.toString()}');
        result.forEach((item) {
          isChecked.add(item.isTaken);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  String _formatHour(int hourDisplayed, int minuteDisplayed) {
    String minute = "";
    String hour = "";
    if (hourDisplayed < 10) {
      hour = "0" + "$hourDisplayed";
    } else {
      hour = "$hourDisplayed";
    }
    if (minuteDisplayed < 10) {
      minute = "0" + "${minuteDisplayed}";
    } else {
      minute = "${minuteDisplayed}";
    }
    if (hourDisplayed < 13)
      return hour + ":" + minute + " am";
    else
      return hour + ":" + minute + " pm";
  }

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];
  bool isShowingShowCase = false;

  void initTargets() {
    targets.add(buildTarget(
      keyTarget: _checkDrug,
      description: "Nhấp để xác nhận đã uống thuốc này",
      enableOverlayTab: true,
      enableTargetTab: false,
      contentAlign: ContentAlign.bottom,
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(buildTarget(
      keyTarget: _checkFinishAll,
      description: "Nhấp để xác nhận đã hoàn thành uống thuốc",
      enableOverlayTab: true,
      enableTargetTab: false,
      contentAlign: ContentAlign.bottom,
      shape: ShapeLightFocus.RRect,
      paddingFocus: 20,
    ));
    targets.add(buildTarget(
      keyTarget: _checkCaptureDrugBtn,
      description: "Hoặc nhấp để nhận diện thuốc bạn uống qua ảnh",
      enableOverlayTab: true,
      enableTargetTab: false,
      shape: ShapeLightFocus.RRect,
    ));
  }

  void showTutorial() {
    if (!ShowCaseSetting.instance.notiScreen || isShowingShowCase) {
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
    isShowingShowCase = true;
  }

  completeShowCases() {
    ShowCaseSetting.instance.updateWith({
      ShowCaseSettingKey.notiScreen: false,
    });
  }
}
