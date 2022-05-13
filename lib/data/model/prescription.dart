import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/prescription_notification.dart';
import 'package:emed/shared/setting/firebase_const.dart';
import 'package:flutter/material.dart';

class Prescription {
  String id;
  String image_url;
  String local_image_url;
  String diagnose;
  String symptom;
  DateTime createdAt;
  DateTime completedAt;
  int nDaysPerWeek;
  List<Drug> listPill;
  List<PrescriptionNotification> notifications = [];

  Prescription({
    @required this.id,
    @required this.image_url,
    @required this.local_image_url,
    this.diagnose = '',
    this.symptom = '',
    @required this.createdAt,
    @required this.completedAt,
    @required this.nDaysPerWeek,
    @required this.listPill,
    this.notifications = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      FirebaseConstant.image: image_url,
      'local_image_url': local_image_url,
      FirebaseConstant.diagnose: diagnose,
      FirebaseConstant.medList: listPill.map((pill) => pill.toMap()).toList(),
      FirebaseConstant.id: id,
      FirebaseConstant.completedTime: completedAt,
      FirebaseConstant.createdTime: createdAt,
      FirebaseConstant.symptom: symptom,
      FirebaseConstant.notifications:
          notifications.map((noti) => noti.toMap()).toList(),
    };
  }

  Prescription.fromMap(Map<String, dynamic> map) {
    id = map[FirebaseConstant.id];
    image_url = map[FirebaseConstant.image];
    local_image_url = map['local_image_url'];
    createdAt = (map[FirebaseConstant.createdTime] as Timestamp).toDate();
    completedAt = (map[FirebaseConstant.completedTime] as Timestamp).toDate();
    diagnose = map[FirebaseConstant.symptom];
    symptom = map[FirebaseConstant.diagnose];
    nDaysPerWeek = 3;
    listPill = (map[FirebaseConstant.medList] as List)
        .map((map) => Drug.fromMap(map))
        .toList();
    notifications = (map[FirebaseConstant.notifications] as List)
        .map((map) => PrescriptionNotification.fromMap(map))
        .toList();
  }

  DateTime get startedDate => _getStartedDate();

  _getStartedDate() {
    DateTime startDate = listPill[0].startedAt;
    for (int i = 1; i < listPill.length; i++) {
      if (startDate.isAfter(listPill[i].startedAt)) {
        startDate = listPill[i].startedAt;
      }
    }
    return startDate;
  }

  Prescription makeCopy() {
    return Prescription(
      id: id,
      image_url: image_url,
      local_image_url: local_image_url,
      diagnose: diagnose,
      symptom: symptom,
      createdAt:
          DateTime.fromMicrosecondsSinceEpoch(createdAt.microsecondsSinceEpoch),
      completedAt: DateTime.fromMicrosecondsSinceEpoch(
          completedAt.microsecondsSinceEpoch),
      nDaysPerWeek: nDaysPerWeek,
      listPill: listPill.map((e) => e.makeCopy()).toList(),
      notifications: notifications.map((e) => e.makeCopy()).toList(),
    );
  }
}
