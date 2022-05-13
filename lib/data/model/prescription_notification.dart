import 'package:emed/shared/setting/firebase_const.dart';
import 'package:flutter/material.dart';

class PrescriptionNotification {
  int notificationId;
  int millisecondsSinceEpoch;

  PrescriptionNotification({@required int id, @required time})
      : this.notificationId = id,
        this.millisecondsSinceEpoch = time;

  PrescriptionNotification.fromMap(Map map) {
    notificationId = map[FirebaseConstant.notificationId];
    millisecondsSinceEpoch = map[FirebaseConstant.millisecondsSinceEpoch];
  }

  Map<String, dynamic> toMap() {
    return {
      FirebaseConstant.notificationId: notificationId,
      FirebaseConstant.millisecondsSinceEpoch: millisecondsSinceEpoch,
    };
  }

  PrescriptionNotification makeCopy() {
    return PrescriptionNotification(
      id: notificationId,
      time: millisecondsSinceEpoch,
    );
  }
}
