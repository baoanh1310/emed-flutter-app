import 'package:emed/components/text_field_input.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:emed/constants.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:emed/components/ButtonImage.dart';
import "package:emed/components/Button.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendMailForgotPasswordScreen extends StatefulWidget {
  SendMailForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _SendMailForgotPasswordState createState() => _SendMailForgotPasswordState();
}

class _SendMailForgotPasswordState extends State<SendMailForgotPasswordScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  String _email = "";
  String _errorEmail = "";

  void _sendEmail() async {
    if (_email == "") {
      setState(() {
        _errorEmail = "Bạn chưa nhập email";
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _email);
      setState(() {
        _errorEmail = "";
      });
      NavigationService().pushNamed(ROUTER_CONFIRM_EMAIL_FORGOTPASSWORD);
    } on FirebaseAuthException catch (e) {} catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  ButtonImage(
                    image: "assets/icons/arrow_back.png",
                    onPressed: () => NavigationService().pop(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  Text("Đặt lại mật khẩu",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Color.fromRGBO(12, 24, 39, 1),
                          fontWeight: FontWeight.w500,
                          fontFamily: "SanFrancisco",
                          fontSize: 18.sp)),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  Text(
                      "Nhập email được liên kết với tài khoảng của bạn và chúng tôi sẽ gửi một email kèm theo hướng dẫn tới",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Color.fromRGBO(151, 151, 151, 1),
                          fontWeight: FontWeight.w500,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.sp)),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                  ),
                  RoundedInputField(
                    label: "Địa chỉ email",
                    hintText: "Nhập email của bạn",
                    onChanged: (value) {
                      _email = value;
                    },
                    errorText: _errorEmail,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  Spacer(),
                  Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 30, right: 0, left: 0),
                          child: CustomButton(
                            radius: 10,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            text: "Gửi hướng dẫn",
                            fontSize: 14.sp,
                            textColor: Colors.white,

                            // gradientColors: const [secondColor, firstColor],
                            onPressed: () => _sendEmail(),
                            background: kPrimaryColorApp,
                          )))
                ]),
          ),
        ),
        inAsyncCall: _isLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}
