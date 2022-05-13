import 'package:flutter/material.dart';
import 'components/capture_body.dart';

class CaptureScreen extends StatelessWidget {
  bool isPill = false;
  CaptureScreen({this.isPill});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CaptureBody(isPill),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
