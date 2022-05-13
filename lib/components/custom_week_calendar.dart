import 'package:flutter/material.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomWeekCalendar extends StatelessWidget {
  Map<String, bool> drugDay;

  final Function(Map<String, bool>) setDrugDay;
  bool isEnable;
  CustomWeekCalendar(this.drugDay, this.isEnable, this.setDrugDay);

  @override
  Widget build(BuildContext context) {
    // print('hungvv - drugday $drugDay');
    // drugDay.forEach((key, value) {
    //   print(key);
    //   print(value);
    // });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            if (isEnable) {
              drugDay['T2'] = !drugDay['T2'];
              setDrugDay(drugDay);
            }
          },
          child: CircleAvatar(
            child: Text('T2',
                style: TextStyle(
                    color: drugDay['T2']
                        ? Colors.white
                        : Color.fromRGBO(12, 24, 39, 1),
                    fontWeight: FontWeight.w500,
                    fontFamily: "SanFrancisco",
                    fontSize: 14.nsp)),
            backgroundColor:
                drugDay['T2'] ? kPrimaryColor : kCalendarBackgroundColor,
          ),
        ),
        InkWell(
          onTap: () {
            if (isEnable) {
              drugDay['T3'] = !drugDay['T3'];
              setDrugDay(drugDay);
            }
          },
          child: CircleAvatar(
            child: Text('T3',
                style: TextStyle(
                    color: drugDay['T3']
                        ? Colors.white
                        : Color.fromRGBO(12, 24, 39, 1),
                    fontWeight: FontWeight.w500,
                    fontFamily: "SanFrancisco",
                    fontSize: 14.nsp)),
            backgroundColor:
                drugDay['T3'] ? kPrimaryColor : kCalendarBackgroundColor,
          ),
        ),
        InkWell(
          onTap: () {
            if (isEnable) {
              drugDay['T4'] = !drugDay['T4'];
              setDrugDay(drugDay);
            }
          },
          child: CircleAvatar(
            child: Text('T4',
                style: TextStyle(
                    color: drugDay['T4']
                        ? Colors.white
                        : Color.fromRGBO(12, 24, 39, 1),
                    fontWeight: FontWeight.w500,
                    fontFamily: "SanFrancisco",
                    fontSize: 14.nsp)),
            backgroundColor:
                drugDay['T4'] ? kPrimaryColor : kCalendarBackgroundColor,
          ),
        ),
        InkWell(
          onTap: () {
            if (isEnable) {
              drugDay['T5'] = !drugDay['T5'];
              setDrugDay(drugDay);
            }
          },
          child: CircleAvatar(
            child: Text('T5',
                style: TextStyle(
                    color: drugDay['T5']
                        ? Colors.white
                        : Color.fromRGBO(12, 24, 39, 1),
                    fontWeight: FontWeight.w500,
                    fontFamily: "SanFrancisco",
                    fontSize: 14.nsp)),
            backgroundColor:
                drugDay['T5'] ? kPrimaryColor : kCalendarBackgroundColor,
          ),
        ),
        InkWell(
          onTap: () {
            if (isEnable) {
              drugDay['T6'] = !drugDay['T6'];
              setDrugDay(drugDay);
            }
          },
          child: CircleAvatar(
            child: Text('T6',
                style: TextStyle(
                    color: drugDay['T6']
                        ? Colors.white
                        : Color.fromRGBO(12, 24, 39, 1),
                    fontWeight: FontWeight.w500,
                    fontFamily: "SanFrancisco",
                    fontSize: 14.nsp)),
            backgroundColor:
                drugDay['T6'] ? kPrimaryColor : kCalendarBackgroundColor,
          ),
        ),
        InkWell(
          onTap: () {
            if (isEnable) {
              drugDay['T7'] = !drugDay['T7'];
              setDrugDay(drugDay);
            }
          },
          child: CircleAvatar(
            child: Text('T7',
                style: TextStyle(
                    color: drugDay['T7']
                        ? Colors.white
                        : Color.fromRGBO(12, 24, 39, 1),
                    fontWeight: FontWeight.w500,
                    fontFamily: "SanFrancisco",
                    fontSize: 14.nsp)),
            backgroundColor:
                drugDay['T7'] ? kPrimaryColor : kCalendarBackgroundColor,
          ),
        ),
        InkWell(
          onTap: () {
            if (isEnable) {
              drugDay['CN'] = !drugDay['CN'];
              setDrugDay(drugDay);
            }
          },
          child: CircleAvatar(
            child: Text('CN',
                style: TextStyle(
                    color: drugDay['CN']
                        ? Colors.white
                        : Color.fromRGBO(12, 24, 39, 1),
                    fontWeight: FontWeight.w500,
                    fontFamily: "SanFrancisco",
                    fontSize: 14.nsp)),
            backgroundColor:
                drugDay['CN'] ? kPrimaryColor : kCalendarBackgroundColor,
          ),
        ),
      ],
    );
  }
}
