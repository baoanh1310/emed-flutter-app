import 'package:emed/main.dart';
import "package:flutter/material.dart";
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = FirebaseAuth.instance;

  //  load du lieu tinh trang nguoi dung

  void fetchSomething() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _isHaveData = prefs.getString("userId") ?? "";

    print(_isHaveData);
    if (_isHaveData.isEmpty) {
      // Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => DisplayPictureScreen(
      //                           imagePath: widget.image_path)));

      NavigationService().pushReplacementNamed(ROUTER_MAIN);
    } else {
      NavigationService().pushReplacementNamed(ROUTER_INTRODUCTION);
      // NavigationService().pushReplacementNamed(ROUTER_AUTH);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 200), () {
      if (_auth.currentUser != null) {
        NavigationService().pushReplacementNamed(ROUTER_MAIN);
        // NavigationService().pushReplacementNamed(ROUTER_ADD_PRESCRIPTION);
        if (selectedNotificationPayload != null) {
          NavigationService().pushNamed(NOTIFICATION_SCREEN,
              arguments: {'payload': selectedNotificationPayload});
        }
      } else
        NavigationService().pushReplacementNamed(ROUTER_INTRODUCTION);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(128, 180, 214, 1),
                    Color.fromRGBO(91, 186, 204, 1),
                    Color.fromRGBO(79, 189, 201, 1)
                  ]),
            ),
            padding: EdgeInsets.symmetric(horizontal: 90.0),
            child: Image.asset("assets/images/logo_splashscreen.png",
                fit: BoxFit.scaleDown),
          ),
        ],
      ),
    );
  }
}
