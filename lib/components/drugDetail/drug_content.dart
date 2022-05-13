import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emed/shared/setting/constant.dart';
import 'package:emed/screen/drug/drug_detail_logic.dart';

class DrugDetailContent extends StatelessWidget {
  final Map drug;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DrugDetailContent(this.drug);

  Future<String> getUrlImagePath(
      {String registerId = "", String doesUnit = ""}) async {
    String imagePath = await DrugDetailScreenLogic()
        .getDrugImage(registerId: registerId, doseUnit: doesUnit);
    String imageUrl =
        await DrugDetailScreenLogic().getUrlUpdate(imagePath: imagePath);
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(0),
        margin:
            EdgeInsets.only(bottom: 25.h, left: 25.w, right: 25.w, top: 7.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(1, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          Container(
            // width: double.infinity,
            padding: EdgeInsets.all(25.0.w),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: kDrugDetailBackgroundColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(drug['tenThuoc'],
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: "SanFrancisco",
                              fontSize: 18.0.sp)),
                      SizedBox(height: 20.h),
                      Text('Số Đăng Ký: ${drug['soDangKy']}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "SanFrancisco",
                              fontSize: 11.0.sp)),
                      SizedBox(height: 10.h),
                      Text('Công Ty SX: ${drug['congTySx']}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "SanFrancisco",
                              fontSize: 11.0.sp)),
                      SizedBox(height: 10.h),
                      Text('Nước SX: ${drug['nuocSx']}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "SanFrancisco",
                              fontSize: 11.0.sp)),
                      SizedBox(height: 10.h),
                      Text('Nhóm thuốc: ${drug['nhomThuoc']}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "SanFrancisco",
                              fontSize: 11.0.sp)),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                FutureBuilder(
                    future: getUrlImagePath(registerId: drug['soDangKy']),
                    builder: (ctx, snapshot) {
                      print(snapshot.data);
                      if (snapshot.connectionState == ConnectionState.done)
                        return Expanded(
                            flex: 4,
                            child: snapshot.data != ""
                                ? Image.network(
                                    snapshot.data,
                                  )
                                : Image.asset("assets/images/default_drug.png",
                                    fit: BoxFit.scaleDown));
                      else
                        return Center(child: CircularProgressIndicator());
                    })
              ],
            ),
          ),
          Container(
            // width: double.infinity,
            padding: EdgeInsets.only(
                left: 25.w, right: 25.w, bottom: 25.h, top: 25.h),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Thành phần: ',
                      style: TextStyle(
                          color: kHightLightColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.0.sp),
                      children: <TextSpan>[
                        TextSpan(
                            text: drug['hoatChat'],
                            style: TextStyle(
                                color: kDrugTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 12.0.sp))
                      ]),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                      text: 'Dạng bào chế: ',
                      style: TextStyle(
                          color: kHightLightColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.0.sp),
                      children: <TextSpan>[
                        TextSpan(
                            text: drug['dangBaoChe'],
                            style: TextStyle(
                                color: kDrugTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 12.0.sp))
                      ]),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                      text: 'Đóng gói: ',
                      style: TextStyle(
                          color: kHightLightColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.0.sp),
                      children: <TextSpan>[
                        TextSpan(
                            text: drug['dongGoi'],
                            style: TextStyle(
                                color: kDrugTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 12.0.sp))
                      ]),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                      text: 'Chỉ định: ',
                      style: TextStyle(
                          color: kHightLightColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.0.sp),
                      children: <TextSpan>[
                        TextSpan(
                            text: drug['chiDinh'],
                            style: TextStyle(
                                color: kDrugTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 12.0.sp))
                      ]),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                      text: 'Chống chỉ định: ',
                      style: TextStyle(
                          color: kHightLightColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.0.sp),
                      children: <TextSpan>[
                        TextSpan(
                            text: drug['chongChiDinh'],
                            style: TextStyle(
                                color: kDrugTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 12.0.sp))
                      ]),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                      text: 'Tác dụng phụ: ',
                      style: TextStyle(
                          color: kHightLightColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.0.sp),
                      children: <TextSpan>[
                        TextSpan(
                            text: drug['tacDungPhu'],
                            style: TextStyle(
                                color: kDrugTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 12.0.sp))
                      ]),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                      text: 'Cách dùng: ',
                      style: TextStyle(
                          color: kHightLightColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SanFrancisco",
                          fontSize: 12.0.sp),
                      children: <TextSpan>[
                        TextSpan(
                            text: drug['cachDung'],
                            style: TextStyle(
                                color: kDrugTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: "SanFrancisco",
                                fontSize: 12.0.sp))
                      ]),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
