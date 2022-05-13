import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'package:emed/shared/widget/my_icon.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCalendar extends StatefulWidget {
  final TextStyle textStyle;
  final Function onchangeDated;
  HomeCalendar({Key key, this.textStyle, this.onchangeDated}) : super(key: key);

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar>
    with TickerProviderStateMixin {
  TextStyle get _textStyle =>
      widget.textStyle ??
      TextStyle(
        color: Color(0xFF495699),
      );
  CalendarController _calendarController;
  AnimationController _animationController;
  bool _isShowToday = true;
  String headerDate = "";

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (_updateWeekData != null) {
    //     final start = _calendarController.visibleDays.first;
    //     final end = _calendarController.visibleDays.last;
    //     refresh(start, end);
    //   }
    // });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    // print(day);
    // final today = DateTime.now();
    if (_isShowToday == true)
      setState(() {
        _isShowToday = false;
      });
    if (widget.onchangeDated != null) {
      widget.onchangeDated(day);
    }
    // if (day.compareTo(today) != 0) {}
  }

  void _goToToday() {
    var today = DateTime.now();
    _calendarController.setFocusedDay(today);
    _calendarController.setSelectedDay(today);
    if (_isShowToday == false)
      setState(() {
        _isShowToday = true;
      });
    if (widget.onchangeDated != null) {
      widget.onchangeDated(today);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeaderCalendar(),
        SizedBox(height: 10.w),
        TableCalendar(
          locale: "vi_VN",
          calendarController: _calendarController,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          calendarStyle: CalendarStyle(
            outsideStyle: _textStyle,
            outsideWeekendStyle: _textStyle,
            highlightSelected: true,
            weekdayStyle: _textStyle,
            weekendStyle: _textStyle,
            todayColor: _isShowToday ? Color(0xFF1AADBB) : Colors.transparent,
            todayStyle: _textStyle,
            selectedColor: Color(0xFF1AADBB),
            outsideDaysVisible: false,
            contentPadding: EdgeInsets.zero,
          ),
          headerVisible: false,
          availableCalendarFormats: {CalendarFormat.week: 'Tuần'},
          initialCalendarFormat: CalendarFormat.week,
          onDaySelected: _onDaySelected,
          onVisibleDaysChanged: (first, last, calendarFormat) async {
            setState(() {});
          },
        ),
        // _buildMediationHistory(data),
      ],
    );
  }

  Widget _buildHeaderCalendar() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(
            DateFormat.yMMMMd("vi_VN").format(
                _calendarController.focusedDay != null
                    ? _calendarController.focusedDay
                    : DateTime.now()),
            style: TextStyle(
                color: Color(0xFF6A6A6A),
                fontWeight: FontWeight.w500,
                fontFamily: "SanFrancisco",
                fontSize: 13.sp),
          )),
          GestureDetector(
              onTap: () {
                _goToToday();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      "Thuốc hôm nay",
                      style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontWeight: FontWeight.w500,
                          fontFamily: "SanFrancisco",
                          fontSize: 13.sp),
                    ),
                    SizedBox(width: 5),
                    MyIcon(
                      svgIconPath: 'assets/icons/date_icon.svg',
                      color: Color(0xFF1AADBB),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFEFF7F7),
                ),
              ))
        ]));
  }
}
