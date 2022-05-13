import "package:flutter/material.dart";
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import "package:emed/components/text_field_input.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);
  static const String id = 'register';

  @override
  _RegisterScreenState createState() => new _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _email = "";
  String _password = "";
  String _repeatPassword = "";
  String _errorEmail = "";
  String _errorPassword = "";
  String _errorRepeatPassword = "";

  bool _checkMailFormat() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
  }

  void _register() async {
    if (!_checkMailFormat()) {
      setState(() {
        _errorEmail = "Không đúng dạng email";
        _isLoading = false;
      });
      return;
    }
    if (_repeatPassword != _password) {
      setState(() {
        _errorPassword = "Không trùng password. Yêu cầu nhập lại";
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);
      if (userCredential != null) {
        if (_errorEmail != "" || _errorPassword != "") {
          setState(() {
            _errorEmail = "";
            _errorPassword = "";
          });
        }
        NavigationService().pushReplacementNamed(ROUTER_MAIN);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _errorPassword = "Mật khẩu chưa đủ mạnh. Yêu cầu nhập lại";
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _errorEmail = "Tài khoản đã tồn tại";
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToLoginScreen() {
    NavigationService().pushReplacementNamed(ROUTER_AUTH);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                  ),
                  Text(
                    "Đăng kí",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(12, 24, 39, 1),
                        fontWeight: FontWeight.w600,
                        fontFamily: "SanFrancisco",
                        fontSize: 36.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  RoundedInputField(
                    label: "Địa chỉ email",
                    hintText: "Nhập email của bạn",
                    errorText: _errorEmail,
                    onChanged: (value) {
                      _email = value.trim();
                    },
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  RoundedInputField(
                    label: "Mật khẩu",
                    hintText: "Nhập mật khẩu của bạn",
                    onChanged: (value) {
                      _password = value.trim();
                    },
                    errorText: _errorPassword,
                    obscureText: true,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  RoundedInputField(
                    label: "Nhập lại mật khẩu",
                    hintText: "Nhập mật khẩu của bạn",
                    onChanged: (value) {
                      _repeatPassword = value.trim();
                    },
                    errorText: _errorRepeatPassword,
                    obscureText: true,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
                    child: FlatButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Đăng kí",
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
                        onPressed: () => _register()),
                  ),
                  Spacer(),
                  Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Bạn đã có tài khoản ?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(12, 24, 39, 1),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "SanFrancisco",
                                      fontSize: 14.sp)),
                              GestureDetector(
                                onTap: () {
                                  _goToLoginScreen();
                                },
                                child: new Text(" Đăng nhập",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Color.fromRGBO(26, 173, 187, 1),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "SanFrancisco",
                                        fontSize: 14.sp)),
                              ),
                            ],
                          )))
                ],
              ),
            ),
          ),
        ),
        inAsyncCall: _isLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}
