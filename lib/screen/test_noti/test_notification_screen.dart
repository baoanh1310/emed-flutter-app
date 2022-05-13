import 'dart:math';

import 'package:emed/data/model/show_case_setting.dart';
import 'package:emed/data/repository/notification_repository.dart';
import 'package:emed/data/repository/notification_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TestNotificationScreen extends StatefulWidget {
  TestNotificationScreen({Key key}) : super(key: key);

  @override
  _TestNotificationScreenState createState() => _TestNotificationScreenState();
}

class _TestNotificationScreenState extends State<TestNotificationScreen> {
  NotificationRepository repository = NotificationRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Notify after 5s'),
            onTap: () {
              scheduleNoti(DateTime.now().add(Duration(seconds: 5)),
                  note: '5s');
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text('Notify after 15s'),
            onTap: () {
              scheduleNoti(DateTime.now().add(Duration(seconds: 15)),
                  note: '15s');
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text('Notify after 30s'),
            onTap: () {
              scheduleNoti(DateTime.now().add(Duration(seconds: 30)),
                  note: '30s');
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text('Notify after 1 min'),
            onTap: () {
              scheduleNoti(DateTime.now().add(Duration(minutes: 1)),
                  note: '1m');
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text('Notify after 2 min'),
            onTap: () {
              scheduleNoti(DateTime.now().add(Duration(minutes: 2)),
                  note: '2m');
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text('Show pending notofications'),
            onTap: () async {
              await _checkPendingNotificationRequests();
            },
          ),
          SizedBox(
            height: 10,
          ),
          Builder(
            builder: (mContext) => ListTile(
              title: Text('Cancel all notifications'),
              onTap: () async {
                await _cancelAllNotifications();
                Scaffold.of(mContext).showSnackBar(
                  SnackBar(
                    content: Text('Clear all notifications successfully!'),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          SizedBox(height: 10),
          Builder(
            builder: (mContext) => ListTile(
              title: Text('Reset tutorials'),
              onTap: () {
                ShowCaseSetting.instance.reset();
                Scaffold.of(mContext).showSnackBar(
                  SnackBar(
                    content: Text('Reset tutorials successfully!'),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // scheduleNoti(DateTime time, {String note = ''}) {
  //   final id = generateRandomInt();
  //   print('Phungtd: new Noti id: $id');
  //   repository.schedule(NotificationDetail(
  //     id: id,
  //     time: time,
  //     title: 'Test title $note',
  //     body: 'Test bodyyy $note',
  //   ));
  // }
  scheduleNoti(DateTime time, {String note = ''}) {
    final id = generateRandomInt();
    print('Phungtd: new Noti id: $id');
    repository.schedule(NotificationDetail(
        id: id,
        time: time,
        title: null,
        body:
            'Hãy đảm bảo bạn đừng bỏ lỡ nó! Uống những thuốc trong khung giờ ${_getHourAndMinute(time)} và đánh dấu nó là đã uống',
        payload: 'Cus tom pay load . . .'));
  }

  String _getHourAndMinute(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    final hourText = hour < 10 ? '0$hour' : '$hour';
    final minuteText = minute < 10 ? '0$minute' : '$minute';
    return '$hourText:$minuteText';
  }

  int generateRandomInt() {
    final random = Random();
    return random.nextInt(2147483647);
  }

  Future<void> _checkPendingNotificationRequests() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content:
            Text('${pendingNotificationRequests.length} pending notification '
                'requests'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelAllNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
