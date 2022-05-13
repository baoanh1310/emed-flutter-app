import 'package:emed/data/model/drug_history_time.dart';
import 'package:emed/shared/setting/firebase_const.dart';

import 'drug.dart';

class DrugHistoryItem {
  String id;
  String prescriptionId;
  String name;
  String image;

  List<DrugHistoryTime> drugTimeList;
  int amount;
  int note;
  String doseUnit;

  DrugHistoryItem.fromDrug(Drug drug) {
    id = drug.id;
    name = drug.name;
    image = '';
    doseUnit = drug.doseUnit;
    // TODO add note to drug item
    note = 0;
    amount = drug.amount;
    drugTimeList =
        drug.drugTimeList.map((e) => DrugHistoryTime.fromDrugTime(e)).toList();
  }

  DrugHistoryItem.fromMap(Map map) {
    id = map[FirebaseConstant.id];
    prescriptionId = map[FirebaseConstant.prescriptionId];
    name = map[FirebaseConstant.medName];
    image = map[FirebaseConstant.image];
    doseUnit = map[FirebaseConstant.unit];
    // TODO add note to drug item
    note = 0;
    amount = map[FirebaseConstant.amount];
    drugTimeList = (map[FirebaseConstant.medTime] as List)
        .map((map) => DrugHistoryTime.fromMap(map))
        .toList();
  }

  Map toMap() {
    return {
      FirebaseConstant.image: image,
      FirebaseConstant.medTime: drugTimeList.map((e) => e.toMap()).toList(),
      FirebaseConstant.amount: amount,
      FirebaseConstant.note: note,
      FirebaseConstant.medName: name,
      FirebaseConstant.id: id,
      FirebaseConstant.unit: doseUnit,
      FirebaseConstant.prescriptionId: prescriptionId,
    };
  }
}
