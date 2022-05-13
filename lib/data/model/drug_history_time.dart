import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emed/data/model/drug_time.dart';
import 'package:emed/shared/setting/firebase_const.dart';
import 'package:flutter/material.dart';

class DrugHistoryTime {
  int hour = 8;
  int minute = 0;
  int takenHour = -1;
  int takenMinute = -1;
  DateTime takenDate = DateTime.now();
  bool isTaken = false;

  DrugHistoryTime({
    @required this.hour,
    @required this.minute,
    this.isTaken,
    this.takenHour,
    this.takenMinute,
    this.takenDate,
  });

  DrugHistoryTime.fromDrugTime(DrugTime time) {
    hour = time.hour;
    minute = time.minute;
    isTaken = false;
  }

  DrugHistoryTime.fromMap(Map map) {
    hour = map[FirebaseConstant.hour];
    minute = map[FirebaseConstant.minute];
    isTaken = map[FirebaseConstant.isTaken];
    takenHour = map[FirebaseConstant.takenHour];
    takenMinute = map[FirebaseConstant.takenMinute];
    takenDate = (map[FirebaseConstant.takenDate] as Timestamp).toDate();
  }

  Map toMap() {
    return {
      FirebaseConstant.hour: hour,
      FirebaseConstant.minute: minute,
      FirebaseConstant.isTaken: isTaken,
      FirebaseConstant.takenHour: takenHour,
      FirebaseConstant.takenMinute: takenMinute,
      FirebaseConstant.takenDate: takenDate,
    };
  }

  bool hasDayTimeAfterNow() {
    final now = DateTime.now();
    return hour * 60 + minute > now.hour * 60 + now.minute;
  }
}
