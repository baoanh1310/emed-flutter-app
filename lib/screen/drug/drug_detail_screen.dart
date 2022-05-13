import 'package:flutter/material.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emed/screen/drug/drug_detail_content.dart';
import 'package:emed/shared/widget/upper_navigation.dart';

class DrugDetailScreen extends StatelessWidget {
  final Map<String, dynamic> drug;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DrugDetailScreen(this.drug);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: 10.h),
          IconBar(),
          SizedBox(height: 10.h),
          // UpperNavigation('Chi Tiết Thuốc'),
          AppBar(title: Text('Chi tiết thuốc'), centerTitle: true),
          SizedBox(height: 10.h),
          Expanded(child: DrugDetailContent(drug)),
        ],
      )),
    );
  }
}
