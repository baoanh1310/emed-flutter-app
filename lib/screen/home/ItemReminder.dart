import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/drug_history_item_time.dart';
import 'package:emed/screen/drug/drug_detail_logic.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:emed/shared/widget/my_icon.dart';
import 'package:flutter/material.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/setting/app_router.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ItemReminder extends StatefulWidget {
  final DrugHistoryItemTime medHistory;
  final DateTime selectedDate;

  ItemReminder({
    Key key,
    this.medHistory,
    this.selectedDate,
  }) : super(key: key);

  @override
  _ItemReminderState createState() => _ItemReminderState();
}

class _ItemReminderState extends State<ItemReminder> {
  int _hourDisplayed;
  int _minuteDisplayed;
  DateTime _dayDisplayed;
  int _takenHour;
  int _takenMinute;
  DateTime _takenDate;
  bool _takenStatus;
  int _takenIntStatus;
  String imageUrl = '';
  String drugID;
  String uid;

  @override
  void initState() {
    super.initState();
    getImageUrl();
  }

  getImageUrl() async {
    // neu ten thuoc == '' thi khong check
    var imageFirestore = '';
    if (widget.medHistory.name != '') {
      drugID = genDrugID(drugName: widget.medHistory.name);
      uid = getUserId();
      var pillFirebaseUrl = "images/$uid/$drugID.jpg";
      imageFirestore = await DrugDetailScreenLogic()
          .getUrlUpdate(imagePath: pillFirebaseUrl);
    }

    setState(() {
      imageUrl = imageFirestore;
      print('hungvv imageurl $imageUrl');
    });
  }

  Widget build(BuildContext ctx) {
    // print('hungvv- ${widget.medHistory.hour}, ${widget.medHistory.minute}');
    if (widget.medHistory.hour != null && widget.medHistory.minute != null) {
      _hourDisplayed = widget.medHistory.hour;
      _minuteDisplayed = widget.medHistory.minute;
      _dayDisplayed = widget.selectedDate;
      _takenHour = widget.medHistory.takenHour;
      _takenMinute = widget.medHistory.takenMinute;
      _takenDate = widget.medHistory
          .takenDate; // mac dinh la ngay hom nay, con neu update se doi lai ngay
      _takenStatus = widget.medHistory.isTaken;
      // print('tenThuoc medhist - ${widget.medHistory.name}');
      _takenIntStatus = _getMedTakenStatus(
          _takenStatus, _hourDisplayed, _minuteDisplayed, _dayDisplayed);
      // print('hungvv taken-int $_takenIntStatus');
    }
    return GestureDetector(
        onTap: () {
          NavigationService().pushNamedAndRemoveUntil(NOTIFICATION_SCREEN,
              (route) {
            return route.settings.name == ROUTER_MAIN;
          }, arguments: {
            'hour': _hourDisplayed,
            'minute': _minuteDisplayed,
            'day': _dayDisplayed,
          });
        },
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(4, 13, 58, 0.1),
                  spreadRadius: 2,
                  blurRadius: 7,
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 12.0, right: 8.0, bottom: 12.0, left: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, //Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment
                          .start, //Center Row contents vertically,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatHour(widget.medHistory),
                              style: Theme.of(ctx).textTheme.bodyText2.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp,
                                  ),
                            ),
                            SizedBox(height: 15.h),
                            _takenIntStatus == 1
                                ? MyIcon(
                                    svgIconPath:
                                        "assets/icons/taken_medicine.svg")
                                : (_takenIntStatus == -1)
                                    ? MyIcon(
                                        svgIconPath: "assets/icons/alert.svg")
                                    : SizedBox(height: 5.h),
                          ],
                        ),
                        SizedBox(width: 5.w),
                        SizedBox(
                          height: 74.h,
                          width: 92.w,
                          child: _showImageDrug(widget.medHistory),
                        ),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: _showContentHistory(
                                    ctx, widget.medHistory))),
                      ],
                    ),
                  )
                ]))));
  }

  Widget _showImageDrug(DrugHistoryItemTime medicine) {
    // if(medicine.)
    //
    // final imageFirestore = await DrugDetailScreenLogic()
    //     .getUrlUpdate(imagePath: this.widget.imageUrl);
    // print('Duyna: The full path url: ${imageFirestore.toString()}');

    // setState(() {
    //   imageUrl = imageFirestore;
    // });

    if (medicine.image == null || medicine.image == "") {
      if (this.imageUrl == '') {
        return Image.asset("assets/images/default_drug.png",
            fit: BoxFit.contain);
      } else
        return Image.network(imageUrl, fit: BoxFit.contain);
    } else {
      return Image.network(medicine.image, height: 200.w, width: 200.w);
    }
  }

  Widget _showContentHistory(BuildContext ctx, DrugHistoryItemTime medicine) {
    // print('hungvv - show medicine note - ${medicine.note}');
    return Column(
      children: [
        Text(
          medicine.name != null ? medicine.name : "",
          maxLines: 2,
          style: TextStyle(
              color: Color.fromRGBO(12, 24, 39, 1),
              fontWeight: FontWeight.w500,
              fontFamily: "SanFrancisco",
              fontSize: 14.sp),
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            MyIcon(
              svgIconPath: "assets/icons/drug_tabbar_icon.svg",
              color: Color(0xFFA3A8BF),
            ),
            SizedBox(width: 10.h),
            Text(
              '${medicine.amount} viên',
              style: Theme.of(ctx)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Color(0xFFA3A8BF)),
            )
          ],
        ),
        (medicine.note == 0)
            ? SizedBox(height: 1.h)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyIcon(
                    svgIconPath: "assets/icons/chat.svg",
                    color: Color(0xFFA3A8BF),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    medicine.note == 0
                        ? ''
                        : (medicine.note == 1
                            ? numberToUnit[TimeConsume.BEFORE]
                            : (medicine.note == 2
                                ? numberToUnit[TimeConsume.WHEN]
                                : (medicine.note == 3
                                    ? numberToUnit[TimeConsume.AFTER]
                                    : ''))),
                    style: Theme.of(ctx)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Color(0xFFA3A8BF)),
                  )
                ],
              ),
        SizedBox(height: 5),
        (_takenHour != -1 && _takenIntStatus != -1)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTakenHour(_takenHour, _takenMinute),
                    style: Theme.of(ctx)
                        .textTheme
                        .bodyText2
                        .copyWith(color: kPrimaryColor),
                  ),
                  Text(
                    _getTakenDate(_takenDate),
                    style: Theme.of(ctx)
                        .textTheme
                        .bodyText2
                        .copyWith(color: kPrimaryColor),
                  ),
                ],
              )
            : _takenIntStatus == -1
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    alignment: Alignment.centerLeft,
                    child: Text('Missed',
                        style: Theme.of(ctx)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.red)),
                  )
                : SizedBox(height: 1.h),
      ],
    );
  }

  String formatHour(DrugHistoryItemTime medicine) {
    String minute = "";
    String hour = "";
    if (medicine.hour < 10) {
      hour = "0" + "${medicine.hour}";
    } else {
      hour = "${medicine.hour}";
    }
    if (medicine.minute < 10) {
      minute = "0" + "${medicine.minute}";
    } else {
      minute = "${medicine.minute}";
    }
    return hour + ":" + minute;
  }

  String _getTakenHour(
    int takenHour,
    int takenMinute,
  ) {
    String res = 'Uống vào lúc ${_formatTime(takenHour, takenMinute)}';
    return res;
  }

  String _getTakenDate(DateTime takenDate) {
    return 'ngày ${_formatDate(takenDate)}';
  }

  String _formatTime(int takenHour, int takenMinute) {
    return '${_getHourStr(takenHour)}:${_getMinuteStr(takenMinute)}';
  }

  String _formatDate(DateTime selectedDate) {
    final f = new DateFormat('dd-MM-yyyy');
    return f.format(selectedDate);
  }

  String _getHourStr(hour) {
    if (hour >= 10) {
      return '$hour';
    }
    return '0$hour';
  }

  String _getMinuteStr(minute) {
    if (minute > 10) {
      return '$minute';
    }
    return '0$minute';
  }

  int _getMedTakenStatus(
      bool isTaken, int _takenHour, int _takenMinute, DateTime _dayDisplayed) {
    // print('isTaken - $isTaken');
    // print(' hour - ${_takenHour}');
    // print(' minute - ${_takenMinute}');
    // print('scheduled hour - ${_takenHour * 60 + _takenMinute}');
    // print('current hour - ${DateTime.now().hour * 60 + DateTime.now().minute}');
    // print('selectedDate - ${_dayDisplayed.toString()}');
    // print('isAfter - ${DateTime.now().isAfter(_dayDisplayed)}');
    if (isTaken) {
      // neu thuoc duoc danh dau da uong
      return 1;
    }
    //neu la ngay truoc thoi diem hien tai
    else if (!isTaken &&
        DateTime.now().isAfter(_dayDisplayed) &&
        DateTime.now().difference(_dayDisplayed).inDays > 0) {
      //chua uong
      // neu thuoc duoc danh dau chua uong, thoi gian hien tai > thoi gian phai uong
      return -1;
    } else if (!isTaken &&
        (DateTime.now().day == _dayDisplayed.day) &&
        (DateTime.now().hour * 60 + DateTime.now().minute >
            _takenHour * 60 + _takenMinute)) {
      return -1;
    } else {
      // neu  chua  den gio uong thuoc
      return 0;
    }
  }
}
