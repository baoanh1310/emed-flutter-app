import 'package:emed/shared/setting/firebase_const.dart';
import 'package:flutter/cupertino.dart';

class DrugTime implements Comparable<DrugTime>{
  int hour = 8;
  int minute = 0;

  DrugTime({@required this.hour, @required this.minute});

  DrugTime.fromMap(Map map) {
    hour = map[FirebaseConstant.hour] ?? 8;
    minute = map[FirebaseConstant.minute] ?? 0;
  }

  Map toMap() {
    return {
      FirebaseConstant.hour: hour,
      FirebaseConstant.minute: minute,
    };
  }

  String formatTime() {
    return '${getHourStr()}\:${getMinuteStr()}';
  }

  String getHourStr() {
    if (hour >= 10) {
      return '$hour';
    }
    return '0$hour';
  }

  String getMinuteStr() {
    if (minute > 10) {
      return '$minute';
    }
    return '0$minute';
  }

  @override
  String toString() {
    return '$hour:$minute';
  }

  DrugTime makeCopy() {
    return DrugTime(
      hour: hour,
      minute: minute,
    );
  }

  @override
  int compareTo(other) {
    return (this.hour * 60 + this.minute) - (other.hour * 60 + other.minute);
  }
}
