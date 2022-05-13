import 'dart:io';

import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/show_case_setting.dart';
import 'package:emed/provider/model/drug_list_model.dart';
import 'package:emed/screen/drug/drug_item.dart';
import 'package:emed/shared/api/drug_api.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/utils/utils.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:emed/screen/drug/drug_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DrugListScreen extends StatefulWidget {
  DrugListScreen({Key key}) : super(key: key);

  @override
  _DrugListScreenState createState() => _DrugListScreenState();
}

class _DrugListScreenState extends State<DrugListScreen>
    with WidgetsBindingObserver {
  // global keys for showcase
  BuildContext myContext;

  GlobalKey _itemShowCaseKey = GlobalKey();

  @override
  void initState() {
    // print('Danh sach thuoc initState');
    super.initState();
    context.read<DrugListModel>().drugs = null;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DrugListModel>().getDrugs(FilterType.USING);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // print('Danh sach thuoc change app life cycle');
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
              padding: EdgeInsets.symmetric(horizontal: 19.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterOptionBar(),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text('Danh sách thuốc'),
                  SizedBox(
                    height: 16.h,
                  ),
                  Expanded(
                    child: Selector<DrugListModel, List<Drug>>(
                        builder: (context, drugList, child) {
                          if (drugList == null) {
                            return Center(child: CircularProgressIndicator());
                          } else if (drugList.isEmpty) {
                            return _buildEmptyDrugList();
                          } else {
                            // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            showTutorial();
                            // });
                            return ListView.separated(
                              // padding: EdgeInsets.symmetric(horizontal: 2.w),
                              itemCount: drugList.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 16.h),
                              itemBuilder: (context, index) => Container(
                                  key: index == 0 ? _itemShowCaseKey : null,
                                  margin: EdgeInsets.all(5.w),
                                  child: DrugItem(item: drugList[index])),
                            );
                          }
                        },
                        selector: (context, model) => model.drugs),
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
    return Selector<DrugListModel, FilterType>(
      selector: (context, model) => model.filter,
      builder: (context, filter, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFilterOption(
            label: 'Thuốc đang uống',
            isSelected: filter == FilterType.USING,
            onTap: () {
              _getPrescriptionList(FilterType.USING);
            },
          ),
          _buildFilterOption(
            label: 'Thuốc đã uống',
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

  _getPrescriptionList(FilterType filterType) {
    context.read<DrugListModel>().getDrugs(filterType);
  }

  Widget _buildEmptyDrugList() {
    return Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 60.w),
              Image.asset("assets/images/drug_list_empty.png",
                  fit: BoxFit.none),
              SizedBox(height: 10.w),
              Text(
                "Danh sách thuốc đã, đang sử dụng",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF4D4D4D),
                    fontWeight: FontWeight.w700,
                    fontFamily: "SanFrancisco",
                    fontSize: 18.sp),
              ),
              SizedBox(height: 20.h),
              Text(
                "Thông tin chi tiết, lịch sử từng loại thuốc",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontWeight: FontWeight.w500,
                    fontFamily: "SanFrancisco",
                    fontSize: 12.sp),
              ),
            ]));
  }

  _navigateToDrug(Drug drug) async {
    print('DUYNA: Navigating to drug detail..');
    final drugId = drug.id;
    if (drugId != '') {
      Map<String, dynamic> result = await getDrugByIdIfMatch(drugId);
      if (result != null) {
        print('Dugna: ${result['soDangKy']}');
        NavigationService()
            .pushNamed(ROUTER_DRUG_DETAIL, arguments: {'drug': result});
      }
    } else {
      final result = drug.toDrugDetailMap();
      NavigationService()
          .pushNamed(ROUTER_DRUG_DETAIL, arguments: {'drug': result});
    }
  }

  _goToFirstDrugDetail() {
    final drugs = context.read<DrugListModel>().drugs;
    if (drugs != null && drugs.length > 0) {
      _navigateToDrug(drugs.first);
    }
  }

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];

  void initTargets() {
    targets.add(
      buildTarget(
        keyTarget: _itemShowCaseKey,
        description: 'Nhấp để xem chi tiết thuốc',
        enableOverlayTab: true,
        enableTargetTab: true,
        contentAlign: ContentAlign.bottom,
        shape: ShapeLightFocus.RRect,
      ),
    );
  }

  bool needToShowTutor() {
    final drugs = context.read<DrugListModel>().drugs;
    return (ShowCaseSetting.instance.drugListScreen &&
        drugs != null &&
        drugs.length > 0);
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
        _goToFirstDrugDetail();
      },
      onFinish: completeShowCases,
      onSkip: completeShowCases,
    )..show();
  }

  completeShowCases() {
    ShowCaseSetting.instance.updateWith({
      ShowCaseSettingKey.drugListScreen: false,
    });
  }
}
