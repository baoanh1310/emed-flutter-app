import 'dart:io';

import 'package:emed/data/model/prescription.dart';
import 'package:emed/data/model/show_case_setting.dart';
import 'package:emed/provider/model/prescription_list_model.dart';
import 'package:emed/screen/prescription/prescription_item.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emed/screen/prescription/prescription_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class PrescriptionListScreen extends StatefulWidget {
  PrescriptionListScreen({Key key}) : super(key: key);

  @override
  _PrescriptionListScreenState createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen>
    with WidgetsBindingObserver {
  final _itemShowCaseKey = GlobalKey();
  @override
  void initState() {
    // print('Danh sach don thuoc initState');
    super.initState();
    context.read<PrescriptionListModel>().prescriptions = null;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PrescriptionListModel>().getPrescriptions(FilterType.USING);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // print('Danh sach don thuoc change app life cycle');
  }

  @override
  Widget build(BuildContext context) {
    // print('Danh sach don thuoc build build build');
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          IconBar(),
          SizedBox(
            height: 12.h,
          ),
          SearchBar(),
          SizedBox(
            height: 24.h,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterOptionBar(),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text('Danh sách đơn thuốc'),
                  SizedBox(
                    height: 16.h,
                  ),
                  Expanded(
                    child: Selector<PrescriptionListModel, List<Prescription>>(
                        builder: (context, prescriptionList, child) {
                          if (prescriptionList == null) {
                            return Center(child: CircularProgressIndicator());
                          } else if (prescriptionList.isEmpty) {
                            return _buildEmptyPrescriptionList();
                          } else {
                            // WidgetsBinding.instance
                            //     .addPostFrameCallback((timeStamp) {
                            showTutorial();
                            // });
                            return ListView.separated(
                              itemCount: prescriptionList.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 16.h),
                              itemBuilder: (context, index) => PrescriptionItem(
                                key: index == 0 ? _itemShowCaseKey : null,
                                item: prescriptionList[index],
                                onItemClick: _goToPrescriptionDetail,
                              ),
                            );
                          }
                        },
                        selector: (context, model) => model.prescriptions),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildFilterOptionBar() {
    return Selector<PrescriptionListModel, FilterType>(
      selector: (context, model) => model.filter,
      builder: (context, filter, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFilterOption(
            label: 'Đơn đang uống',
            isSelected: filter == FilterType.USING,
            onTap: () {
              _getPrescriptionList(FilterType.USING);
            },
          ),
          _buildFilterOption(
            label: 'Đơn đã uống',
            isSelected: filter == FilterType.COMPLETED,
            onTap: () {
              _getPrescriptionList(FilterType.COMPLETED);
            },
          ),
          _buildFilterOption(
            label: 'Tất cả',
            isSelected: filter == FilterType.ALL,
            onTap: () {
              _getPrescriptionList(FilterType.ALL);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption({String label, bool isSelected, Function() onTap}) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: const Color.fromRGBO(4, 13, 58, 0.1),
                  spreadRadius: 2,
                  blurRadius: 7,
                )
            ],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyPrescriptionList() {
    return Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 60.w),
              Image.asset("assets/images/pres_list_empty.png",
                  fit: BoxFit.none),
              SizedBox(height: 10.w),
              Text(
                "Đơn thuốc thông minh",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF4D4D4D),
                    fontWeight: FontWeight.w700,
                    fontFamily: "SanFrancisco",
                    fontSize: 18.sp),
              ),
              SizedBox(height: 20.h),
              Text(
                "Tạo lịch uống thuốc tự động từ ảnh đơn thuốc",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontWeight: FontWeight.w500,
                    fontFamily: "SanFrancisco",
                    fontSize: 12.sp),
              ),
            ]));
  }

  _getPrescriptionList(FilterType filterType) {
    context.read<PrescriptionListModel>().getPrescriptions(filterType);
  }

  _goToPrescriptionDetail(Prescription p) {
    NavigationService().pushNamed(ROUTER_PRESCRIPTION_DETAIL, arguments: {
      'prescriptionId': p.id,
    });
  }

  _goToFirstPrescriptionDetail() {
    final prescriptions = context.read<PrescriptionListModel>().prescriptions;
    if (prescriptions != null && prescriptions.length > 0) {
      _goToPrescriptionDetail(prescriptions.first);
    }
  }

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];

  void initTargets() {
    targets.add(
      buildTarget(
        keyTarget: _itemShowCaseKey,
        description: 'Nhấp để xem chi tiết đơn thuốc',
        enableOverlayTab: true,
        enableTargetTab: true,
        contentAlign: ContentAlign.bottom,
        shape: ShapeLightFocus.RRect,
      ),
    );
  }

  bool needToShowTutor() {
    final prescriptions = context.read<PrescriptionListModel>().prescriptions;
    return (ShowCaseSetting.instance.prescriptionListScreen &&
        prescriptions != null &&
        prescriptions.length > 0);
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
        _goToFirstPrescriptionDetail();
      },
      onFinish: completeShowCases,
      onSkip: completeShowCases,
    )..show();
  }

  completeShowCases() {
    ShowCaseSetting.instance.updateWith({
      ShowCaseSettingKey.prescriptionListScreen: false,
    });
  }
}
