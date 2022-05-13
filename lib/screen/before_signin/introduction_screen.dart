import "package:flutter/material.dart";
import 'dart:async';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroductionScreen extends StatefulWidget {
  IntroductionScreen({Key key}) : super(key: key);

  @override
  _IntroductionScreenState createState() => new _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  Future<void> _goToLoginScreen() {
    return NavigationService().pushReplacementNamed(ROUTER_AUTH);
  }

  Future<void> _goToRegisterScreen() {
    return NavigationService().pushReplacementNamed(ROUTER_REGISTER);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image:
                  new AssetImage("assets/images/background_introduction.png"),
              fit: BoxFit.cover,
              // scale: 0.5,
            ),
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Image.asset("assets/images/pill_logo.png",
                        fit: BoxFit.scaleDown),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    // Text(
                    //   "eMed",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       color: Color.fromRGBO(26, 173, 187, 1),
                    //       fontWeight: FontWeight.w400,
                    //       fontFamily: "SanFrancisco",
                    //       fontSize: 24.sp),
                    // ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text(
                      "Thêm kế hoạch sử dụng thuốc của bạn",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(98, 128, 168, 1),
                          fontWeight: FontWeight.w400,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.sp),
                    ),
                    Text(
                      "không bao giờ đơn giản đến vậy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(98, 128, 168, 1),
                          fontWeight: FontWeight.w400,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.sp),
                    ),
                  ]))),
          Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                        child: Text("Đăng kí miễn phí",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 14.sp)),
                        color: Color.fromRGBO(26, 173, 187, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () => _goToRegisterScreen()),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    GestureDetector(
                      onTap: () {
                        _goToLoginScreen();
                      },
                      child: new Text("Hoặc đăng nhập",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(26, 173, 187, 1),
                              fontWeight: FontWeight.w500,
                              fontFamily: "SanFrancisco",
                              fontSize: 14.sp)),
                    )
                  ]))
        ]),
      ],
    ));
  }
}
