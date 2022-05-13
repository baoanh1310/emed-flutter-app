import 'package:flutter/material.dart';

class TestNotificationDetailScreen extends StatefulWidget {
  final String payload;
  TestNotificationDetailScreen({Key key, @required this.payload}) : super(key: key);

  @override
  _TestNotificationDetailScreenState createState() => _TestNotificationDetailScreenState();
}

class _TestNotificationDetailScreenState extends State<TestNotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Notification: payload: ${widget.payload}'),
      ),
    );
  }
}
