import 'package:emed/screen/pill_result/pill_result_card.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      body: ModalProgressHUD(
        child: SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.h),
            IconBar(),
            SizedBox(height: 10.h),
            // PillResultCard(),
            // TODO: setting component,
            SizedBox(height: 10.h),
            FutureBuilder<bool>(
              future: _canLaunchFeedback(),
              builder: (_, snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  return ListTile(
                    onTap: _launchFeedback,
                    leading: Icon(Icons.email),
                    title: Text('Góp ý'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                    ),
                  );
                }
                return Container();
              },
            ),

            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: FlatButton(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Đăng xuất",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SanFrancisco",
                            fontSize: 14.0)),
                    color: Color.fromRGBO(26, 173, 187, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () => _logout()),
              ),
            ),
          ],
        )),
        inAsyncCall: _isLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signOut();
      setState(() {
        _isLoading = false;
      });
      NavigationService().popAndPushNamed(ROUTER_AUTH);
    } catch (e) {
      print('LOGOUT ERROR: ${e}');
    }
  }

  Future<bool> _canLaunchFeedback() async {
    final _browserLaunchUri = Uri.parse(FEEDBACK_URL);
    final _canLaunch = await canLaunch(_browserLaunchUri.toString());
    print(
        'Phungtd: _canLaunchFeedback with uri: ${_browserLaunchUri.toString()} : $_canLaunch');
    return _canLaunch;
  }

  _launchFeedback() async {
    final _browserLaunchUri = Uri.parse(FEEDBACK_URL);
    launch(_browserLaunchUri.toString());
  }
}
