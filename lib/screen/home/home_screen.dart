import 'dart:io';

import 'package:emed/data/model/drug_history_item_time.dart';
import 'package:emed/provider/model/screen_reload_model.dart';
import 'package:flutter/material.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emed/screen/home/Calendar.dart';
import 'package:emed/data/repository/prescription_repository.dart';
import 'package:emed/data/service_locator.dart';
import "package:emed/screen/home/ItemReminder.dart";
import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:emed/data/model/show_case_setting.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/setting/app_router.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrescriptionRepository prescriptionRepository =
      serviceLocator<PrescriptionRepository>();

  // CalendarController _calendarController;
  bool _isLoading = false;
  DateTime _selectedCalendarDate;
  List<DrugHistoryItemTime> result = [];
  int oldReloadState = 0;
  // List<UserQuestionNotify> lstUserQuestionNotify = [];
  final _itemShowCaseKey = GlobalKey();

  TutorialCoachMark tutorial; // init tutorial
  List<TargetFocus> targets = [];

  @override
  void initState() {
    super.initState();
    // print('DUYNA: uid: ${getUserId()}');
    _selectedCalendarDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getMedHistory(_selectedCalendarDate);
    });
    // _calendarController = CalendarController();
    context.read<ScreenReloadModel>().addListener(() {
      final newReloadState = context.read<ScreenReloadModel>().homeScreenState;
      if (oldReloadState < newReloadState) {
        oldReloadState = newReloadState;
        reload();
      }
    });
  }

  // void dispose() {
  //   _calendarController.dispose();
  //   super.dispose();
  // }

  void _getMedHistory(DateTime selectedDate) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final medicineHistory =
          await prescriptionRepository.getMedHistoryEachDay(selectedDate);
      // final listUserNote = await prescriptionRepository.getUserQuestionNotify();
      print(medicineHistory);
      setState(() {
        result = medicineHistory;
        // set lai ngay dang chon
        _selectedCalendarDate = selectedDate;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('hungvvvvvvvvvvvvvvvv');
    // lstUserQuestionNotify.forEach((element) {
    //   print('${element.startDate.toString()}');
    // });
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          IconBar(),
          SizedBox(
            height: 12,
          ),
          HomeCalendar(onchangeDated: _getMedHistory),
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xFFECE9EF),
          ),
          Selector<ScreenReloadModel, int>(
            selector: (_, model) => model.homeScreenState,
            builder: (_, __, ___) {
              print('reloading');
              return _buildEmptyMedicine();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMedicine() {
    if (_isLoading) {
      return Container(
        child: CircularProgressIndicator(),
        padding: EdgeInsets.symmetric(vertical: 50.w),
      );
    } else if (_isLoading == false && result.length > 0) {
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showTutorial();
      // });
      return Expanded(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Scrollbar(
                child: ListView.separated(
                    itemCount: result.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.w),
                    itemBuilder: (BuildContext context, int index) {
                      return ItemReminder(
                        key: index == 0 ? _itemShowCaseKey : null,
                        medHistory: result[index],
                        selectedDate: _selectedCalendarDate,
                      );
                    }),
              )));
    }
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          SizedBox(height: 60.w),
          Image.asset("assets/images/no_drug_today.png", fit: BoxFit.none),
          SizedBox(height: 10.w),
          Text(
            "Quản lí lịch uống thuốc",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF4D4D4D),
                fontWeight: FontWeight.w700,
                fontFamily: "SanFrancisco",
                fontSize: 18.sp),
          ),
          SizedBox(height: 20),
          Text(
            "Thêm kế hoạch sử dụng thuốc của bạn",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF9B9B9B),
                fontWeight: FontWeight.w500,
                fontFamily: "SanFrancisco",
                fontSize: 12.sp),
          ),
        ]));
  }

  reload() {
    _getMedHistory(_selectedCalendarDate);
  }

  void initTargets() {
    targets.add(
      buildTarget(
        keyTarget: _itemShowCaseKey,
        description: 'Nhấp để xác nhận uống thuốc',
        enableOverlayTab: true,
        enableTargetTab: true,
        contentAlign: ContentAlign.bottom,
        shape: ShapeLightFocus.RRect,
      ),
    );
  }

  bool needToShowTutor() {
    // print('Do dai cua list result: ${result.length}');
    // print(
    //     'bool medHstory screem: ${ShowCaseSetting.instance.medHistoryScreen}');
    // khong hien showcase neu list thuoc uong ngay hom nay len =0
    return (ShowCaseSetting.instance.medHistoryScreen &&
        result != null &&
        result.length > 0);
  }

  void showTutorial() {
    if (!needToShowTutor()) {
      return;
    }
    sleep(Duration(milliseconds: 200));

    initTargets();
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      textSkip: "Bỏ qua",
      hideSkip: true,
      paddingFocus: 0,
      focusAnimationDuration: Duration(milliseconds: 300),
      pulseAnimationDuration: Duration(milliseconds: 500),
      onClickOverlay: (_) {
        tutorial.next();
      },
      onClickTarget: (_) {
        _goToScheduleScreen();
      },
      onFinish: completeShowCases,
      onSkip: completeShowCases,
    )..show();
  }

  completeShowCases() {
    //set key = false de khong hien nua
    ShowCaseSetting.instance.updateWith({
      ShowCaseSettingKey.medHistoryScreen: false,
    });
  }

  _goToScheduleScreen() {
    if (result != null && result.length > 0)
      NavigationService().pushNamedAndRemoveUntil(NOTIFICATION_SCREEN, (route) {
        return route.settings.name == ROUTER_MAIN;
      }, arguments: {
        'hour': result[0].hour,
        'minute': result[0].minute,
        'day': _selectedCalendarDate,
      });
  }
}
