import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emed/data/repository/notification_repository.dart';
import 'package:emed/shared/setting/firebase_const.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<void> schedule(NotificationDetail detail) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'noti channel id',
      'noti channel name',
      'noti description',
      priority: Priority.max,
      importance: Importance.max,
      visibility: NotificationVisibility.public,
    );
    const iosPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    final location = tz.getLocation(currentTimeZone);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      detail.id,
      detail.title,
      detail.body,
      tz.TZDateTime.from(detail.time, location),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidAllowWhileIdle: true,
      payload: detail.payload,
    );
  }

  @override
  Future<void> cancel(int id) {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    return flutterLocalNotificationsPlugin.cancel(id);
  }

  /// notiId and time of payload in [oldNoti] will be replaced,
  /// uid and prescriptionId of payload will be the same
  /// time, title and body of [oldNoti] will be ignored
  @override
  Future<void> remindLater(
      {NotificationDetail oldNoti, int newId, int minute}) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancel(oldNoti.id);
    final oldPayload = NotificationPayload.fromJson(oldNoti.payload);
    final nextTime = DateTime.now().add(Duration(minutes: minute));
    await updateNotificationInfoInFirestore(oldPayload, newId, nextTime);
    final newPayload = oldPayload.copyWith(
        notiId: newId, time: nextTime.millisecondsSinceEpoch);
    final newNoti = NotificationDetail(
      id: newId,
      time: nextTime,
      title: null,
      body:
          'Hãy đảm bảo bạn đừng bỏ lỡ nó! Uống những thuốc trong khung giờ ${getHourAndMinute(nextTime)} và đánh dấu nó là đã uống',
      payload: newPayload.toJson(),
    );
    return schedule(newNoti);
  }

  updateNotificationInfoInFirestore(
    NotificationPayload oldPayload,
    int newId,
    DateTime rescheduledTime,
  ) async {
    final userHistoryRef = FirebaseFirestore.instance
        .collection(FirebaseConstant.prescription)
        .doc(oldPayload.uid)
        .collection(FirebaseConstant.prescriptionList)
        .doc(oldPayload.prescriptionId);
    final prescriptionDoc = await userHistoryRef.get();
    if (!prescriptionDoc.exists) {
      return;
    }
    final notificationList =
        prescriptionDoc.get(FirebaseConstant.notifications) as List;
    final notiIndex = notificationList.indexWhere((element) =>
        element[FirebaseConstant.millisecondsSinceEpoch] == oldPayload.time);

    if (notiIndex == -1) {
      print('Phungtd: NotificationRepositoryImpl -> '
          'updateNotificationInfoInFirestore -> '
          'no noti found for uid: ${oldPayload.uid}, '
          'prescription: ${oldPayload.prescriptionId} '
          'with time stamp: ${oldPayload.time}');
      return;
    }

    notificationList[notiIndex][FirebaseConstant.notificationId] = newId;
    notificationList[notiIndex][FirebaseConstant.millisecondsSinceEpoch] =
        rescheduledTime.millisecondsSinceEpoch;
  }
}
