import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:flutter/material.dart';
import "package:emed/constants.dart";
import 'auth_screen_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import "package:emed/components/text_field_input.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  AuthScreenLogic logic = AuthScreenLogic();
  bool _isLoading = false;
  bool _isRememberMe = false;
  String _email = "";
  String _password = "";
  String _errorEmail = "";
  String _errorPassword = "";

  void _login() async {
    print('Start logging in...');
    setState(() {
      _isLoading = true;
      _errorEmail = "";
      _errorPassword = "";
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
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
      print("log authentication");
      print(e.message);
      if (e.code == 'user-not-found') {
        setState(() {
          _errorEmail = "Không tồn tại người dùng này";
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _errorPassword = "Không đúng mật khẩu";
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

  Widget buildRememberMe() {
    return Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: _isRememberMe ? kPrimaryColor : Colors.white,
            border:
                Border.all(width: 2, color: Color.fromRGBO(26, 173, 187, 1))),
        child: _isRememberMe
            ? Icon(Icons.check, color: Colors.white, size: 10)
            : null);
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
                Image.asset(
                  "assets/images/login_image.png",
                  fit: BoxFit.none,
                  height: 150,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Text(
                  "Đăng nhập",
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
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        buildRememberMe(),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRememberMe = !_isRememberMe;
                            });
                          },
                          child: new Text("Nhớ tôi",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Color.fromRGBO(26, 173, 187, 1),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "SanFrancisco",
                                  fontSize: 14.sp)),
                        ),
                      ],
                    )),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          NavigationService()
                              .pushNamed(ROUTER_SEND_EMAIL_FORGOTPASSWORD);
                        },
                        child: Text("Quên mật khẩu?",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Color.fromRGBO(26, 173, 187, 1),
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 14.sp)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: FlatButton(
                      padding: EdgeInsets.all(15.0),
                      child: Text("Đăng nhập",
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
                      onPressed: () => _login()),
                ),
                Spacer(),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Bạn chưa có tài khoản ?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(12, 24, 39, 1),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SanFrancisco",
                                    fontSize: 14.sp)),
                            GestureDetector(
                              onTap: () {
                                NavigationService()
                                    .pushReplacementNamed(ROUTER_REGISTER);
                              },
                              child: new Text(" Đăng kí",
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
          )),
        ),
        inAsyncCall: _isLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }
}
