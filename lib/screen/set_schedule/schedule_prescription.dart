import 'package:emed/components/generic_snackbar.dart';
import 'package:emed/data/model/drug_time.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/provider/model/screen_reload_model.dart';
import 'package:emed/screen/set_schedule/schedule_screen_logic.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:emed/components/ButtonImage.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import "./schedule_screen.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/data/model/drug.dart';
import 'package:emed/shared/setting/app_router.dart';

class SchedulePrescriptionScreen extends StatefulWidget {
  final Prescription prescription;
  final bool isFromEditPrescription;
  final int indexDrug;
  SchedulePrescriptionScreen({
    Key key,
    @required this.prescription,
    this.isFromEditPrescription = false,
    this.indexDrug,
  }) : super(key: key);

  @override
  _SchedulePrescriptionScreenState createState() =>
      _SchedulePrescriptionScreenState();
}

class _SchedulePrescriptionScreenState
    extends State<SchedulePrescriptionScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  ScheduleScreenLogic logic;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  Prescription get oldPrescription => widget.prescription;
  Prescription currentPrescription;
  bool get isFromEditPrescription => widget.isFromEditPrescription;
  int currentPageIndex = 0;

  @override
  void initState() {
    logic = ScheduleScreenLogic(context);
    currentPrescription = oldPrescription.makeCopy();
    _pageController.addListener(() {
      setState(() {
        currentPageIndex = _pageController.page.round();
      });
    });
    // print('hungvv- drugid ');
    // print(widget.prescription.listPill[0].id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentPrescription != null) {
      return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        body: widget.isFromEditPrescription
            ? SafeArea(
                child: ModalProgressHUD(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.w),
                      IconBar(),
                      SizedBox(height: 10.w),
                      Row(
                        children: [
                          ButtonImage(
                            image: "assets/icons/arrow_back.png",
                            onPressed: () => NavigationService().pop(),
                            // NavigationService().pop(),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text("Đặt lịch uống thuốc",
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(12, 24, 39, 1),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "SanFrancisco",
                                  fontSize: 16.sp)),
                        ],
                      ),
                      SizedBox(height: 10.w),
                      Expanded(
                        child: ScheduleScreen(
                            medicine:
                                currentPrescription.listPill[widget.indexDrug],
                            index: widget.indexDrug,
                            prescriptionsLength: 0,
                            applyToAll: applyToAll),
                      ),
                      SizedBox(height: 8.w),
                      _buildSetScheduleBlock(),
                      SizedBox(height: 8.w),
                    ],
                  ),
                  inAsyncCall: _isLoading,
                  opacity: 0.5,
                  progressIndicator: CircularProgressIndicator(),
                ),
              )
            : SafeArea(
                child: ModalProgressHUD(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10.w),
                      IconBar(),
                      SizedBox(height: 10.w),
                      Row(
                        children: [
                          ButtonImage(
                            image: "assets/icons/arrow_back.png",
                            onPressed: () => NavigationService().pop(),
                            // NavigationService().pop(),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text("Đặt lịch uống thuốc",
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(12, 24, 39, 1),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "SanFrancisco",
                                  fontSize: 16.sp)),
                        ],
                      ),
                      SizedBox(height: 10.w),
                      Expanded(
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _pageController,
                          itemCount: currentPrescription.listPill.length,
                          // itemBuilder: (ctx, i) => Container(
                          //   color: i % 2 == 0 ? Colors.pink : Colors.cyan,
                          // ),
                          itemBuilder: (ctx, i) => ScheduleScreen(
                            medicine: currentPrescription.listPill[i],
                            index: i,
                            prescriptionsLength:
                                currentPrescription.listPill.length,
                            applyToAll: applyToAll,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.w),
                      _buildSetScheduleBlock(),
                      SizedBox(height: 8.w),
                    ],
                  ),
                  inAsyncCall: _isLoading,
                  opacity: 0.5,
                  progressIndicator: CircularProgressIndicator(),
                ),
              ),
      );
    } else
      print('Phungtd: SchedulePrescriptionScreen - prescription is null');
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // build list navigate button
  Widget _buildSetScheduleBlock() {
    // neu chi co mot thuoc thi se chi co mot man dat thuoc
    if ((currentPrescription.listPill.length == 1) ||
        (widget.isFromEditPrescription)) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Expanded(child: _buildButtonComplete()),
            Expanded(child: Container()),
          ],
        ),
      );
    }

    if (currentPageIndex == currentPrescription.listPill.length - 1) {
      // neu la man hinh cuoi cung
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: _buildButtonPrevious()),
            Expanded(child: _buildButtonComplete()),
            Expanded(child: Container()),
          ],
        ),
      );
    } else if (currentPageIndex == 0) {
      // neu la man hinh dau tien
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: Container()),
            Expanded(child: Container()),
            Expanded(child: _buildButtonNext()),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildButtonPrevious()),
            Expanded(child: Container()),
            Expanded(child: _buildButtonNext()),
          ],
        ),
      );
    }
  }

  Widget _buildButtonComplete() {
    bool isComplete = true;
    bool isDrugTimeDifferent = true;
    return InkWell(
      onTap: () {
        var curDrug = currentPrescription.listPill.last;
        var strCheckErrorDrug = checkErrorDrug(curDrug);

        if (!strCheckErrorDrug.isEmpty) {
          // neu ton tai loi trong don thuoc thi
          setState(() {
            _isLoading = false;
          });
          // va hien thi snackbar
          GlobalSnackBar.show(_scaffoldKey, context, strCheckErrorDrug);
        } else {
          if (isFromEditPrescription) {
            // neu tu trang edit don thuoc thi update don thuoc
            logic
                .updatePrescription(oldPrescription, currentPrescription)
                .then((successful) {
              if (successful) {
                context
                    .read<ScreenReloadModel>()
                    .markHomeScreenAsNeedReloading();
                NavigationService().pushNamedAndRemoveUntil(
                    ROUTER_PRESCRIPTION_DETAIL, (route) {
                  // print('Phungtd: check remove route: route name: ${route.settings.name}');
                  return route.settings.name == ROUTER_MAIN;
                }, arguments: {
                  'prescriptionId': currentPrescription.id,
                  'prescription': currentPrescription
                });

                setState(() {
                  _isLoading = true;
                });
              } else {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          } else {
            // neu tu trang tao don thuoc moi thi tao don thuoc
            logic.createPrescription(currentPrescription).then((successful) {
              if (successful) {
                print('Duyna: Complete At ${currentPrescription.completedAt}');

                context
                    .read<ScreenReloadModel>()
                    .markHomeScreenAsNeedReloading();
                NavigationService().pushNamedAndRemoveUntil(
                    ROUTER_PRESCRIPTION_DETAIL, (route) {
                  // print('Phungtd: check remove route: route name: ${route.settings.name}');
                  return route.settings.name == ROUTER_MAIN;
                }, arguments: {
                  'prescriptionId': currentPrescription.id,
                  'prescription': currentPrescription
                });

                setState(() {
                  _isLoading = true;
                });
              } else {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(5.w),
        ),
        child: Text('Hoàn thành',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: "SanFrancisco",
                fontSize: 14.sp)),
      ),
    );
  }

  Widget _buildButtonPrevious() {
    return ScheduleNavigationButton(
      press: goToPreviousPage,
      btnText: "Thuốc trước",
      icon: Icons.navigate_before,
      btnType: BtnType.PREVIOUS,
    );
  }

  Widget _buildButtonNext() {
    return ScheduleNavigationButton(
      press: goToNextPage,
      btnText: "Thuốc sau",
      icon: Icons.navigate_next,
      btnType: BtnType.NEXT,
    );
  }

  goToPreviousPage() {
    setState(() {
      currentPageIndex--;
      _pageController.previousPage(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    });
  }

  goToNextPage() {
    //get current drug: if error -> show snackBar else next page
    var curDrug = currentPrescription.listPill[currentPageIndex];
    var strCheckErrorDrug = checkErrorDrug(curDrug);
    if (!strCheckErrorDrug.isEmpty) {
      GlobalSnackBar.show(_scaffoldKey, context, strCheckErrorDrug);
    } else {
      setState(() {
        currentPageIndex++;
        _pageController.nextPage(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeIn,
        );
      });
    }
  }

  applyToAll(Drug model) {
    //TODO: add more general logic
    currentPrescription.listPill.forEach((element) {
      element.startedAt = model.startedAt;
      element.completedAt = model.completedAt;
      // element.amount = model.amount;
      element.dayOfWeekList = model.dayOfWeekList;
      element.nDaysPerWeek = model.nDaysPerWeek;
      element.drugDays = model.drugDays; // cac ngay trong tuan uong thuoc
      print(model.drugDays);
    });
  }

  slidePage(currentPage) {
    _pageController.animateToPage(
      currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  checkErrorDrug(Drug drug) {
    //check thuoc co gio uong trung khong va
    // check thuoc co ton tai ngay uong nao khong
    //neu khong co loi nao tra ve list rong
    bool errorSameTimeDrug = checkSameTimeDrug(drug);
    bool errorExistDrugDay = checkExistDrugDay(drug);
    if (!errorSameTimeDrug) // neu ton tai loi trung gio uong thuoc
      return 'Tồn tại giờ uống thuốc trùng nhau';
    else if (!errorExistDrugDay) // neu ton tai loi khong co ngay uong thuoc nao
      return 'Không tồn tại ngày uống thuốc trong tuần';
    return '';
  }

  checkSameTimeDrug(Drug drug) {
    // check co ton tai 2 gio uong thuoc giong nhau khong
    List<DrugTime> newDrugTime = [];
    drug.drugTimeList.forEach((drugTime) {
      // newDrugTime.add(drugTime);
      var idx = newDrugTime.indexWhere(
          (e) => ((drugTime.hour == e.hour) & (drugTime.minute == e.minute)));
      if (idx == -1) newDrugTime.add(drugTime);
    });
    print('hungvv - length set drug: ${newDrugTime.length}');
    print('hungvv - set drug: ${newDrugTime}');
    print('hungvv - length list  drug: ${drug.drugTimeList.length}');
    if (newDrugTime.length != drug.drugTimeList.length) return false;
    return true;
  }

  checkExistDrugDay(Drug drug) {
    // check truong hop khong co ngay nao uong thuoc
    if (drug.dayOfWeekList.isEmpty) {
      return false;
    }
    return true;
  }
}

class ScheduleNavigationButton extends StatelessWidget {
  final Function press;
  final String btnText;
  final IconData icon;
  final BtnType btnType;
  const ScheduleNavigationButton({
    Key key,
    @required this.btnText,
    @required this.press,
    @required this.btnType,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (btnType == BtnType.NEXT)
      return InkWell(
        onTap: press,
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              btnText,
              // textAlign: TextAlign.center,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp),
            ),
            Icon(
              icon,
              color: kPrimaryColor,
              size: 18.w,
            ),
          ],
        ),
      );
    else if (btnType == BtnType.PREVIOUS)
      return InkWell(
        onTap: press,
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: kPrimaryColor,
              size: 18.w,
            ),
            Text(
              btnText,
              // textAlign: TextAlign.center,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp),
            ),
          ],
        ),
      );
  }
}

enum BtnType { PREVIOUS, NEXT }
