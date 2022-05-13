import 'package:emed/shared/api/drug_api.dart';
import 'package:flutter/material.dart';
import 'package:emed/shared/widget/icon_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emed/components/drugDetail/drug_content.dart';
import 'package:emed/shared/widget/upper_navigation.dart';

class DrugDetailComponent extends StatefulWidget {
  final String partialName;
  DrugDetailComponent(this.partialName);

  @override
  _DrugDetailComponentState createState() => _DrugDetailComponentState();
}

class _DrugDetailComponentState extends State<DrugDetailComponent> {
  Map drug = {};
  bool isLoading = false;
  bool isResult = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDrugDetail();
    });
  }

  void getDrugDetail() async {
    try {
      setState(() {
        isLoading = true;
        isResult = false;
      });
      final matches = await getDrugByNameIfMatch(widget.partialName);
      if (matches.length > 0) {
        setState(() {
          drug = matches[0];
          isResult = true;
        });
      }
    } catch (error) {} finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
          Expanded(child: _buildRenderDrug()),
        ],
      )),
    );
  }

  Widget _buildRenderDrug() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (isResult) {
      return DrugDetailContent(drug);
    } else {
      return Center(
          child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
            Image.asset("assets/images/no_drug_today.png", fit: BoxFit.none),
            SizedBox(height: 10.w),
            Text(
              "Chưa có thông tin về thuốc này",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF4D4D4D),
                  fontWeight: FontWeight.w700,
                  fontFamily: "SanFrancisco",
                  fontSize: 18.0),
            ),
          ])));
    }
  }
}
