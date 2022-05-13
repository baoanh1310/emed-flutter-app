import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:emed/constants.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import "package:emed/components/Button.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmMailForgotPasswordScreen extends StatefulWidget {
  ConfirmMailForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ConfirmMailForgotPasswordState createState() =>
      _ConfirmMailForgotPasswordState();
}

class _ConfirmMailForgotPasswordState
    extends State<ConfirmMailForgotPasswordScreen> {
  final _isLoading = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
              child: SizedBox(
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                ),
                Image.asset(
                  "assets/images/confirm_forgotpassword.png",
                  fit: BoxFit.none,
                  height: 150,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                Text("Kiểm tra hộp thư của bạn",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(12, 24, 39, 1),
                        fontWeight: FontWeight.w500,
                        fontFamily: "SanFrancisco",
                        fontSize: 16.sp)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40),
                  child: Text(
                      "Chúng tôi đã gửi một mật khẩu khôi phục hướng dẫn đến email của bạn",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(98, 128, 168, 0.5),
                          fontWeight: FontWeight.w500,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.sp)),
                ),
                CustomButton(
                  radius: 10,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  text: "Quay lại đăng nhập",
                  fontSize: 14.sp,
                  textColor: Colors.white,

                  // gradientColors: const [secondColor, firstColor],
                  onPressed: () =>
                      NavigationService().pushReplacementNamed(ROUTER_AUTH),
                  background: kPrimaryColorApp,
                ),
                Spacer(),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                            "Không nhận được email. Hãy kiểm tra thư rác của bạn hoặc Thử một email khác",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(12, 24, 39, 1),
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 14.sp)),
                      ),
                    ))
              ],
            ),
          )),
        ),
        inAsyncCall: _isLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}
