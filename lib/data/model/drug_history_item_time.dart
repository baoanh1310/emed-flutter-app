import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emed/data/model/drug_history_time.dart';
import 'package:emed/shared/setting/firebase_const.dart';

import 'drug.dart';

class DrugHistoryItemTime implements Comparable {
  String id;
  String prescriptionId;
  String name;
  String image;

  int amount;
  int note;
  int hour = 8;
  int minute = 0;
  int takenHour = -1;
  int takenMinute = -1;
  DateTime takenDate = DateTime.now();
  bool isTaken = false;
  bool isOutside = false;

  DrugHistoryItemTime.fromMap(Map map) {
    prescriptionId = map[FirebaseConstant.prescriptionId];
    hour = map[FirebaseConstant.hour];
    minute = map[FirebaseConstant.minute];
    takenHour = map[FirebaseConstant.takenHour];
    takenMinute = map[FirebaseConstant.takenMinute];
    takenDate = (map[FirebaseConstant.takenDate] as Timestamp).toDate();
    isTaken = map[FirebaseConstant.isTaken];
    id = map[FirebaseConstant.id];
    name = map[FirebaseConstant.medName];
    image = map[FirebaseConstant.image];
    // TODO add note to drug item
    note = 0;
    amount = map[FirebaseConstant.amount];
  }
  @override
  int compareTo(other) {
    if (this.hour < other.hour) {
      return -1;
    }
    if (this.hour > other.hour) {
      return 1;
    }
    if (this.hour == other.hour) {
      if (this.minute > other.minute) {
        return 1;
      }
      if (this.minute < other.minute) {
        return -1;
      } else {
        return 0;
      }
    }
  }

  Map toMap() {
    return {
      FirebaseConstant.hour: hour,
      FirebaseConstant.minute: minute,
      FirebaseConstant.takenHour: takenHour,
      FirebaseConstant.takenMinute: takenMinute,
      FirebaseConstant.takenDate: takenDate,
      FirebaseConstant.isTaken: isTaken,
      FirebaseConstant.amount: amount,
      FirebaseConstant.note: note,
      FirebaseConstant.medName: name,
      FirebaseConstant.id: id,
      FirebaseConstant.image: image,
      FirebaseConstant.prescriptionId: prescriptionId,
    };
  }

  Map toFirebaseMap() {
    return {
      FirebaseConstant.medTime: [
        {
          FirebaseConstant.hour: hour,
          FirebaseConstant.minute: minute,
          FirebaseConstant.takenHour: takenHour,
          FirebaseConstant.takenMinute: takenMinute,
          FirebaseConstant.takenDate: takenDate,
          FirebaseConstant.isTaken: isTaken
        }
      ],
      FirebaseConstant.amount: amount,
      FirebaseConstant.note: note,
      FirebaseConstant.medName: name,
      FirebaseConstant.id: id,
      FirebaseConstant.image: image,
      FirebaseConstant.unit: '1',
      FirebaseConstant.prescriptionId: prescriptionId ?? '',
    };
  }

  // DrugHistoryItem.fromDrug(Drug drug) {
  //   id = drug.id;
  //   name = drug.name;
  //   image = '';
  //   // TODO add note to drug item
  //   note = 0;
  //   amount = drug.amount;
  //   drugTimeList =
  //       drug.drugTimeList.map((e) => DrugHistoryTime.fromDrugTime(e)).toList();
  // }

  // DrugHistoryItem.fromMap(Map map) {
  //   id = map[FirebaseConstant.id];
  //   name = map[FirebaseConstant.medName];
  //   image = map[FirebaseConstant.image];
  //   // TODO add note to drug item
  //   note = 0;
  //   amount = map[FirebaseConstant.amount];
  //   drugTimeList = (map[FirebaseConstant.medTime] as List)
  //       .map((map) => DrugHistoryTime.fromMap(map))
  //       .toList();
  // }

  // Map toMap() {
  //   return {
  //     FirebaseConstant.image: image,
  //     FirebaseConstant.medTime: drugTimeList.map((e) => e.toMap()).toList(),
  //     FirebaseConstant.amount: amount,
  //     FirebaseConstant.note: note,
  //     FirebaseConstant.medName: name,
  //     FirebaseConstant.id: id,
  //   };
  // }
}
