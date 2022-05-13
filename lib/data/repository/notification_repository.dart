import 'dart:convert';

import 'package:flutter/cupertino.dart';

abstract class NotificationRepository {
  Future<void> schedule(NotificationDetail detail);

  Future<void> cancel(int id);

  Future<void> remindLater({
    @required NotificationDetail oldNoti,
    @required int newId,
    @required int minute,
  });
}

class NotificationDetail {
  int id;
  String title;
  String body;
  DateTime time;
  String payload;

  NotificationDetail({
    @required this.id,
    this.title = '',
    this.body = '',
    @required this.time,
    this.payload = '',
  });
}

class NotificationPayload {
  int notiId;
  String uid;
  String prescriptionId;
  int time;   // the time that the notification will show up
  int originalTime; // the time that the med was scheduled at first

  NotificationPayload({
    @required this.notiId,
    @required this.uid,
    @required this.prescriptionId,
    @required this.time,
    @required this.originalTime,
  });

  NotificationPayload.fromJson(String json) {
    final map = jsonDecode(json);
    notiId = map['notiId'];
    uid = map['uid'];
    prescriptionId = map['prescriptionId'];
    time = map['time'];
    originalTime = map['originalTime'];
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'notiId': notiId,
      'uid': uid,
      'prescriptionId': prescriptionId,
      'time': time,
      'originalTime': originalTime,
    };
  }

  NotificationPayload copyWith({
    int notiId,
    String uid,
    String prescriptionId,
    int time,
  }) {
    return NotificationPayload(
      notiId: notiId ?? this.notiId,
      uid: uid ?? this.uid,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      time: time ?? this.time,
      originalTime: this.originalTime,
    );
  }
}
