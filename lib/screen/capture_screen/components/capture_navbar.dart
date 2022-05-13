import 'dart:io';

import 'package:emed/data/model/show_case_setting.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:emed/components/default_outline_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CaptureNavbar extends StatefulWidget {
  CaptureNavbar(
      {Key key,
      this.pressGetImage,
      this.pressCaptureImage,
      this.pressDirectInstruction})
      : super(key: key);

  final Function pressGetImage;
  final Function pressCaptureImage;
  final Function pressDirectInstruction;

  @override
  _CaptureNavbarState createState() => _CaptureNavbarState();
}

class _CaptureNavbarState extends State<CaptureNavbar> {
  // global keys for showcase
  GlobalKey _captureBtn = GlobalKey();
  GlobalKey _uploadBtn = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showTutorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.1),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.w),
          topRight: Radius.circular(40.w),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Row(
                children: [
                  Spacer(),
                  DefaultOutlineButton(
                    key: _uploadBtn,
                    text: "Tải lên",
                    borderColor: ThemeData().copyWith().primaryColor,
                    textColor: ThemeData().copyWith().primaryColor,
                    press: widget.pressGetImage,
                  ),
                  SizedBox(width: 32.w),
                ],
              ),
            ),
            IconButton(
              key: _captureBtn,
              iconSize: 40.w,
              // padding: new EdgeInsets.all(0.0),
              icon: SvgPicture.asset('assets/icons/camera_button.svg'),
              onPressed: widget.pressCaptureImage,
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 30.w),
                  GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icons/instruction.svg"),
                        Text(
                          "Hướng dẫn",
                          style: TextStyle(
                              color: ThemeData().copyWith().primaryColor),
                        ),
                      ],
                    ),
                    onTap: widget.pressDirectInstruction,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];

  void initTargets() {
    targets.add(
      buildTarget(
        keyTarget: _captureBtn,
        description: 'Nhấp để chụp ảnh',
        enableOverlayTab: true,
        enableTargetTab: false,
      ),
    );
    targets.add(
      buildTarget(
        keyTarget: _uploadBtn,
        description: 'Hoặc nhấp để tải lên ảnh từ thư viện',
        enableOverlayTab: true,
        enableTargetTab: false,
        shape: ShapeLightFocus.RRect,
      ),
    );
  }

  void showTutorial() {
    if (!ShowCaseSetting.instance.captureScreen) {
      return;
    }
    sleep(Duration(milliseconds: 200));
    initTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      textSkip: "Bỏ qua",
      paddingFocus: 0,
      focusAnimationDuration: Duration(milliseconds: 300),
      pulseAnimationDuration: Duration(milliseconds: 500),
      onClickOverlay: (_) {
        tutorial.next();
      },
      onFinish: completeShowCases,
      onSkip: completeShowCases,
    )..show();
  }

  completeShowCases() {
    ShowCaseSetting.instance.updateWith({
      ShowCaseSettingKey.captureScreen: false,
    });
  }
}
