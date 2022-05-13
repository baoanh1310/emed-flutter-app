import 'package:emed/data/model/drug.dart';
import 'package:emed/data/model/prescription.dart';
import 'package:emed/provider/model/prescription_detail_model.dart';
import 'package:emed/screen/picture_display/picture_display_screen.dart';
import 'package:emed/screen/prescription_detail/my_calendar.dart';
import 'package:emed/screen/prescription_detail/prescription_detail_logic.dart';
import 'package:emed/screen/set_schedule/schedule_prescription.dart';
import 'package:emed/shared/setting/app_router.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:emed/shared/extension/string.dart';
import 'package:emed/shared/widget/imageButton.dart';
import 'package:emed/shared/widget/my_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import "package:emed/shared/utils/utils.dart";
import "package:emed/shared/extension/date.dart";

class PrescriptionDetailScreen extends StatefulWidget {
  final String prescriptionId;
  final Prescription prescription;

  PrescriptionDetailScreen({Key key, this.prescriptionId, this.prescription})
      : super(key: key);

  @override
  _PrescriptionDetailScreenState createState() =>
      _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
  String get prescriptionId => widget.prescriptionId;

  Prescription get prescription => widget.prescription;

  bool get _needPullDataFromServer =>
      prescription == null && prescriptionId != null;

  final _scrollViewController = new ScrollController();
  bool _showBackButton = true;
  bool isScrollingDown = false;

  PrescriptionDetailLogic logic;

  @override
  void initState() {
    logic = PrescriptionDetailLogic(context);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_needPullDataFromServer) {
        logic.getPrescription(prescriptionId);
      } else {
        logic.setPrescription(prescription);
      }

      _scrollViewController.addListener(() {
        if (_scrollViewController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (!isScrollingDown) {
            isScrollingDown = true;
            _showBackButton = false;
            setState(() {});
          }
        }

        if (_scrollViewController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isScrollingDown) {
            isScrollingDown = false;
            _showBackButton = true;
            setState(() {});
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<PrescriptionDetailModel>(
          builder: (context, model, child) {
            if (model.prescription == null) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                IconBar(),
                _buildBackButton(),
                Expanded(
                  child: _buildBody(model.prescription),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(Prescription prescription) {
    return SingleChildScrollView(
      controller: _scrollViewController,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildPrescriptionImage(prescription.image_url),
            SizedBox(
              height: 16,
            ),
            _buildTextBlockHorizontal('Triệu chứng:', prescription.symptom),
            SizedBox(
              height: 8,
            ),
            _buildTextBlockHorizontal('Chẩn đoán:', prescription.diagnose),
            SizedBox(
              height: 24,
            ),
            _buildMediationHistory(prescription),
            // FlatButton(onPressed: null, child: Text('Lưu')),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return AnimatedContainer(
      height: _showBackButton ? 34.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: InkWell(
        onTap: () {
          NavigationService().pop();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/arrow_back.svg'),
          ),
        ),
      ),
    );
  }

  Widget _buildPrescriptionImage(String imgUrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 48.0, right: 16),
      child: Center(
        child: FutureBuilder<String>(
          future: imgUrl.getStorageDownloadUrl(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                              imagePath: snapshot.data, isPill: false)));
                },
                child: Image.network(
                  snapshot.data,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  height: 200.h,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              // this to add pres img
              // return SizedBox(
              //     width: 250.w,
              //     height: 150.w,
              //     child: Align(
              //         alignment: Alignment.center,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Container(
              //               width: 50.w,
              //               height: 30.h,
              //               decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 border: Border.all(
              //                   color: kInputBorderEnableColor,
              //                   style: BorderStyle.solid,
              //                 ),
              //                 borderRadius: BorderRadius.circular(5),
              //               ),
              //               child: Padding(
              //                 padding: EdgeInsets.symmetric(
              //                     horizontal: 12.w, vertical: 5.h),
              //                 child: MyIcon(
              //                   svgIconPath: 'assets/icons/camera.svg',
              //                   color: Color.fromRGBO(115, 115, 115, 1),
              //                 ),
              //               ),
              //             ),
              //             SizedBox(
              //               height: 4.h,
              //             ),
              //             Padding(
              //               padding: EdgeInsets.all(5.w),
              //               child: Text(
              //                 'Nhấp chụp để thêm ảnh đơn thuốc',
              //                 textAlign: TextAlign.center,
              //               ),
              //             )
              //           ],
              //         )));

              return SizedBox(height: 3.h);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextBlockHorizontal(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            content,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildTextBlock(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          content,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildMediationHistory(Prescription prescription) {
    var drugs = prescription.listPill;
    return ListView.separated(
      itemBuilder: (context, index) =>
          _buildMedItem(prescription, drugs[index], index),
      separatorBuilder: (context, index) => SizedBox(
        height: 24,
      ),
      itemCount: drugs.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      primary: false,
    );
  }

  Widget _buildMedItem(Prescription prescription, Drug drug, int index) {
    String drugID = getDrugID(drug);
    String uid = getUserId();
    // final note =
    //     (drug.note == null || drug.note.isEmpty) ? '' : '${drug.note}, ';
    bool isCompleted = prescription.completedAt.isBefore(DateTime.now());
    String tmpNote = timeConsumToString[drug.timeConsume];
    final String note = (tmpNote == null || tmpNote.isEmpty || tmpNote == ' ')
        ? ''
        : '${timeConsumToString[drug.timeConsume]}, ';
    String drugDesc;
    if (note.isEmpty) {
      drugDesc =
          'Ngày ${drug.nTimesPerDay} lần, uống ${drug.startedAt.dayDifference(drug.completedAt)} ngày';
    } else {
      drugDesc =
          'Ngày ${drug.nTimesPerDay} lần, uống ${drug.startedAt.dayDifference(drug.completedAt)} ngày, $note';
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // neu muon sua don thuoc  thi truyen vao prescription va drugIndex
        InkWell(
          onTap: isCompleted
              ? null
              : () {
                  //neu don thuoc hoan thanh thi khong cho sua
                  NavigationService().pushNamed(
                    ROUTER_SCHEDULE,
                    arguments: {
                      'prescription':
                          context.read<PrescriptionDetailModel>().prescription,
                      'isFromEditPrescription': true,
                      'indexDrug': index,
                    },
                  );
                },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildTextBlock('${index + 1}. ${drug.name}', drugDesc),
              ),
              Row(
                children: [
                  if (!isCompleted) Image.asset('assets/icons/edit.png'),
                  SizedBox(
                    width: 20,
                  ),
                  ImageButton(
                    imageUrl: "images/$uid/$drugID.jpg",
                    uploadedImage: true,
                    isCropped: false,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        MyCalendar(updateWeekData: (startDate, endDate) {
          return logic.getMedHistory(
              prescriptionId, drug.name, startDate, endDate,
              timesPerDay: drug.nTimesPerDay);
        }),
      ],
    );
  }
}
