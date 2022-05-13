import 'dart:io';

import 'package:emed/data/model/show_case_setting.dart';
import 'package:emed/main.dart';
import 'package:emed/screen/prescription/prescription_list_screen.dart';
import 'package:emed/screen/test_noti/test_notification_screen.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/screen/drug/drug_list_screen.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:emed/screen/home/home_screen.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:emed/screen/setting/setting_and_logout.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'fab_bottom_app_bar.dart';
import 'navigator_page.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _tabIndex = 0;

// declare global keys
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
  };

  // global keys for showcase
  GlobalKey _addBtn = GlobalKey();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    showTutorial();
    // });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      print(
          'Phungtd: Main Screen - didReceiveLocalNotificationSubject ${receivedNotification.toString()}');
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await NavigationService().pushNamed(NOTIFICATION_SCREEN,
                    arguments: {'payload': receivedNotification.payload});
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await NavigationService()
          .pushNamed(NOTIFICATION_SCREEN, arguments: {'payload': payload});
    });
  }

  @override
  void dispose() {
    print('Phungtd: Main Screen dispose ...');
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            return !await Navigator.maybePop(
                navigatorKeys[_tabIndex].currentState.context);
          },
          child: Container(
            color: Colors.white,
            child: _getSelectedTab(),
          ),
        ),
      ),
      bottomNavigationBar: FABBottomAppBar(
        items: [
          FABBottomAppBarItem(
            svgIconPath: 'assets/icons/home_icon.svg',
          ),
          FABBottomAppBarItem(
            svgIconPath: 'assets/icons/drug_tabbar_icon.svg',
          ),
          FABBottomAppBarItem(
            svgIconPath: 'assets/icons/date_icon.svg',
          ),
          FABBottomAppBarItem(
            svgIconPath: 'assets/icons/setting_icon.svg',
          ),
        ],
        actionButton: _buildActionButton(),
        selectedColor: Theme.of(context).primaryColor,
        unselectedColor: Color(0xFFDADADA),
        backgroundColor: Colors.white,
        onTabSelected: _selectTab,
      ),
    );
  }

  _selectTab(int index) {
    navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    setState(() {
      _tabIndex = index;
    });
  }

  _getSelectedTab() {
    switch (_tabIndex) {
      case 0:
        return NavigatorPage(
          child: HomeScreen(),
          // child: Text('Home'),
          navigatorKey: navigatorKeys[0],
        );
        break;
      case 1:
        return NavigatorPage(
          child: DrugListScreen(),
          navigatorKey: navigatorKeys[1],
        );
        break;
      case 2:
        return NavigatorPage(
          child: PrescriptionListScreen(),
          navigatorKey: navigatorKeys[2],
        );
        break;
      case 3:
        return NavigatorPage(
          child: SettingScreen(),
          // child: PillResultCard(),
          navigatorKey: navigatorKeys[3],
        );
        break;
    }
  }

  _buildActionButton() {
    return Container(
      key: _addBtn,
      height: 54,
      alignment: Alignment.bottomCenter,
      // child: Showcase(
      //   key: _addBtn,
      //   description: 'Tap here to start',
      child: GestureDetector(
        onTap: _onTapActionButton,
        onLongPress: () {
          // if (kDebugMode) {
          if (true) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TestNotificationScreen(),
              ),
            );
          }
        },
        child: Container(
          width: 54.0,
          height: 54.0,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF037382).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 5), // changes position of shadow
                )
              ]),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      // ),
    );
  }

  _onTapActionButton() {
    NavigationService().pushNamed(ROUTER_ADD_PRESCRIPTION);
  }

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];

  void initTargets() {
    targets.add(
      buildTarget(
        id: ShowCaseSettingKey.mainScreen,
        keyTarget: _addBtn,
        description: 'Nhấp để tạo đơn thuốc',
        enableOverlayTab: true,
        enableTargetTab: true,
      ),
    );
  }

  void showTutorial() {
    if (!ShowCaseSetting.instance.mainScreen) {
      return;
    }
    sleep(Duration(milliseconds: 200));

    initTargets();
    tutorial = TutorialCoachMark(context,
        targets: targets,
        textSkip: "Bỏ qua",
        hideSkip: true,
        paddingFocus: 0,
        focusAnimationDuration: Duration(milliseconds: 300),
        pulseAnimationDuration: Duration(milliseconds: 500),
        onClickTarget: (target) {
      print(target.identify);
      if (target.identify == ShowCaseSettingKey.mainScreen) {
        _onTapActionButton();
      }
    }, onClickOverlay: (_) {
      // print('Phungtd: onClickOverlay');
      tutorial.next();
    }, onFinish: () {
      // print('Phungtd: Finishhhhhhhh');
      ShowCaseSetting.instance
          .updateWith({ShowCaseSettingKey.mainScreen: false});
    })
      ..show();
  }
}
