import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef UpdateWeekDataFunction = FutureOr<List<List<MedicationStatus>>>
    Function(
  DateTime startDate,
  DateTime endDate,
);

typedef DayOfWeekTextBuilder = String Function(int dayOfWeek);

enum MedicationStatus {
  MISSED,
  TOOK,
  NECESSARY,
  NOT_NECESSARY,
}

class MyCalendar extends StatefulWidget {
  final UpdateWeekDataFunction updateWeekData;
  final DayOfWeekTextBuilder dayOfWeekTextBuilder;
  final TextStyle textStyle;

  MyCalendar(
      {Key key,
      @required this.updateWeekData,
      this.dayOfWeekTextBuilder,
      this.textStyle})
      : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  UpdateWeekDataFunction get _updateWeekData => widget.updateWeekData;

  DayOfWeekTextBuilder get _dayOfWeekTextBuilder =>
      widget.dayOfWeekTextBuilder ?? _getWeekDayStringFormat;

  TextStyle get _textStyle =>
      widget.textStyle ??
      TextStyle(
        color: Color(0xFF495699),
      );

  CalendarController _calendarController;

  List<List<MedicationStatus>> data = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_updateWeekData != null) {
        final start = _calendarController.visibleDays.first;
        final end = _calendarController.visibleDays.last;
        refresh(start, end);
      }
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableCalendar(),
        _buildMediationHistory(data),
      ],
    );
  }

  TableCalendar _buildTableCalendar() {
    return TableCalendar(
      locale: "vi_VN",
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        outsideStyle: _textStyle,
        outsideWeekendStyle: _textStyle,
        highlightSelected: false,
        weekdayStyle: _textStyle,
        weekendStyle: _textStyle,
        todayColor: Color(0xFF1AADBB),
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
        contentPadding: EdgeInsets.zero,
      ),
      // headerVisible: false,
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonPadding: EdgeInsets.all(0),
        titleTextBuilder: (date, locale) => 'Tháng ${date.month} năm ${date.year}',
        titleTextStyle: TextStyle(fontSize: 15.sp),
        headerPadding: EdgeInsets.all(0),
        rightChevronPadding: EdgeInsets.all(5.h),
        leftChevronPadding: EdgeInsets.all(5.h),
      ),
      availableCalendarFormats: {CalendarFormat.week: 'Tuần'},
      initialCalendarFormat: CalendarFormat.week,
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextBuilder: (date, locale) => _dayOfWeekTextBuilder(date.weekday),
        weekdayStyle: _textStyle,
        weekendStyle: _textStyle,
      ),
      onVisibleDaysChanged: (first, last, calendarFormat) async {
        print('Phungtd: Calendar Format: $calendarFormat');
        print('Phungtd: first date: ${DateFormat.yMd().format(first)}');
        print('Phungtd: last date: ${DateFormat.yMd().format(last)}');

        if (_updateWeekData != null) {
          refresh(first, last);
        }
      },
    );
  }

  refresh(DateTime startDate, DateTime endDate) async {
    setState(() {
      isLoading = true;
    });
    final newData = await _updateWeekData(startDate, endDate);
    if (this.mounted)
      setState(() {
        isLoading = false;
        data = newData;
      });
  }

  String _getWeekDayStringFormat(int weekDay) {
    switch (weekDay) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        return 'T${weekDay + 1}';
      case 7:
        return 'CN';
      default:
        return '';
    }
  }

  Widget _buildMediationHistory(List<List<MedicationStatus>> data) {
    if (isLoading) {
      return CircularProgressIndicator();
    }
    if (data == null || data.isEmpty) {
      return Container();
    }
    final columns = data
        .map((dayHistory) => Expanded(child: _getDayHistory(dayHistory)))
        .toList();
    // print('Phungtd: column length: ${columns.length}');
    int nColumnsToAdd = 7 - columns.length;
    for (int i = 0; i < nColumnsToAdd; i++) {
      columns.add(Expanded(child: Container()));
      // print(i);
      // columns.add(Expanded(child: Icon(Icons.dangerous)));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns,
    );
  }

  Widget _getDayHistory(List<MedicationStatus> dayData) {
    final List<Widget> rows = [];
    for (int i = 0; i < dayData.length; i++) {
      rows.add(_getIconStatus(dayData[i]));
      if (i != dayData.length - 1) {
        rows.add(SizedBox(
          height: 10,
        ));
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  Widget _getIconStatus(MedicationStatus status) {
    switch (status) {
      case MedicationStatus.MISSED:
        return SvgPicture.asset('assets/icons/missed.svg');
      // return Icon(Icons.done);
      case MedicationStatus.TOOK:
        return SvgPicture.asset('assets/icons/took.svg');
      // return Icon(
      //   Icons.lens_outlined,
      //   color: Colors.red,
      // );
      case MedicationStatus.NECESSARY:
        return SvgPicture.asset('assets/icons/necessary.svg');
      // return Icon(
      //   Icons.lens_outlined,
      //   color: Colors.lightBlue,
      // );
      case MedicationStatus.NOT_NECESSARY:
        return SvgPicture.asset('assets/icons/not_necessary.svg');
      // return Icon(
      //   Icons.lens_outlined,
      //   color: Colors.grey,
      // );
      default:
        return Container();
    }
  }
}
