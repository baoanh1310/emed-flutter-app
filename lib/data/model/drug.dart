import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emed/data/model/drug_time.dart';
import 'package:emed/shared/setting/firebase_const.dart';
import 'package:flutter/material.dart';
import 'package:emed/shared/extension/date.dart';

class Drug {
  String id;
  String name;
  String activeIngredient;
  int amount = 1; // lieu dung
  String doseUnit;
  TimeConsume timeConsume;

  DateTime startedAt;
  DateTime completedAt;
  int nDaysPerWeek = 0;
  int nTimesPerDay; // cach dung
  List<int> dayOfWeekList = []; // Monday:1 -> Sunday:7
  List<DrugTime> drugTimeList = [];
  Map<String, bool> drugDays; // Map tu ngay toi true/false
  int presentInPrescriptions = 1;
  String localImagePath = "";
  Drug({
    @required this.id,
    this.name = '',
    this.activeIngredient = '',
    @required this.amount,
    @required this.doseUnit,
    @required this.timeConsume,
    startedAt,
    completedAt,
    @required this.nDaysPerWeek,
    @required this.nTimesPerDay,
    this.dayOfWeekList = const [],
    this.drugTimeList = const [],
    this.localImagePath = "",
    drugDays,
  })  : this.startedAt = startedAt ?? DateTime.now(),
        this.completedAt = completedAt ?? DateTime.now(),
        this.drugDays = drugDays ??
            {
              'T2': false,
              'T3': false,
              'T4': false,
              'T5': false,
              'T6': false,
              'T7': false,
              'CN': false
            };

  Drug.fromMap(Map map) {
    id = map[FirebaseConstant.id];
    name = map[FirebaseConstant.medName];
    amount = map[FirebaseConstant.amount]; // lieu dung
    doseUnit = map[FirebaseConstant.unit];
    // timeConsume;

    startedAt = (map[FirebaseConstant.startedTime] as Timestamp).toDate();
    completedAt = (map[FirebaseConstant.completedTime] as Timestamp).toDate();
    nTimesPerDay = map[FirebaseConstant.howToUse]; // cach dung
    dayOfWeekList = (map[FirebaseConstant.frequency] as List)
        .map((e) => e as int)
        .toList(); // Monday:1 -> Sunday:7
    drugTimeList = (map[FirebaseConstant.medTime] as List)
        .map((map) => DrugTime.fromMap(map))
        .toList();
    nDaysPerWeek = dayOfWeekList.length;
    localImagePath =
        map["local_image_url"] != null ? map["local_image_url"] : "";

    // String note; //sau bua an
  }

  @override
  String toString() {
    return 'Drug: $name, start from ${startedAt.formatDate()} to ${completedAt.formatDate()}, $dayOfWeekList, $drugTimeList, amount each time: $amount ${numberToUnit[doseUnit]}, localImagePath: $localImagePath';
  }

  Map<String, dynamic> toMap() {
    return {
      FirebaseConstant.howToUse: nTimesPerDay,
      FirebaseConstant.medTime: drugTimeList
          .map((time) => {
                FirebaseConstant.hour: time.hour,
                FirebaseConstant.minute: time.minute,
              })
          .toList(),
      FirebaseConstant.amount: amount,
      FirebaseConstant.unit: doseUnit,
      FirebaseConstant.note: '',
      FirebaseConstant.startedTime: startedAt,
      FirebaseConstant.completedTime: completedAt,
      FirebaseConstant.frequency: dayOfWeekList,
      FirebaseConstant.medName: name,
      FirebaseConstant.id: id,
      "local_image_url": localImagePath
    };
  }

  Map<String, dynamic> toDrugDetailMap() {
    return {
      'cachDung': 'Không có trong cơ sở dữ liệu',
      'tenThuoc': name,
      'soDangKy': id,
      "local_image_url": localImagePath,
      'congTySx': 'Không có trong cơ sở dữ liệu',
      'nuocSx': 'Không có trong cơ sở dữ liệu',
      'nhomThuoc': 'Không có trong cơ sở dữ liệu',
      'dangBaoChe': 'Không có trong cơ sở dữ liệu',
      'dongGoi': 'Không có trong cơ sở dữ liệu',
      'chiDinh': 'Không có trong cơ sở dữ liệu',
      'chongChiDinh': 'Không có trong cơ sở dữ liệu',
      'tacDungPhu': 'Không có trong cơ sở dữ liệu',
      'thanhPhan': 'Không có trong cơ sở dữ liệu'
    };
  }

  Drug makeCopy() {
    return Drug(
      id: id,
      name: name,
      activeIngredient: activeIngredient,
      amount: amount,
      doseUnit: doseUnit,
      timeConsume: timeConsume,
      startedAt:
          DateTime.fromMicrosecondsSinceEpoch(startedAt.microsecondsSinceEpoch),
      completedAt: DateTime.fromMicrosecondsSinceEpoch(
          completedAt.microsecondsSinceEpoch),
      nDaysPerWeek: nDaysPerWeek,
      nTimesPerDay: nTimesPerDay,
      dayOfWeekList: [...dayOfWeekList],
      drugTimeList: drugTimeList.map((e) => e.makeCopy()).toList(),
      localImagePath: localImagePath,
      drugDays:
          drugDays, // TODO kiem tra gan gia tri nhu nay co bi chung reference khong
    );
  }

  String getDoseUnitString() {
    return numberToUnit[this.doseUnit];
  }
}

enum TimeConsume { BEFORE, WHEN, AFTER, NONE }

Map<String, String> numberToUnit = {
  '0': "lọ",
  '1': "tube",
  '2': "viên",
  '3': "ống",
  '4': "hộp",
  '5': "gói",
  '6': "bút",
  '7': "chai",
};
//  ['lọ', 'tube', 'viên', 'ống', 'hộp', 'gói', 'bút', 'chai']
Map<TimeConsume, String> timeConsumToString = {
  TimeConsume.NONE: " ",
  TimeConsume.BEFORE: "trước bữa ăn",
  TimeConsume.WHEN: "trong bữa ăn",
  TimeConsume.AFTER: "sau bữa ăn"
};
