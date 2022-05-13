import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String textContent;
  const CustomTextField({
    @required this.textContent,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.fromLTRB(16.w, 5.w, 16.w, 5.w),
      child: Text(
        textContent,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "SansFrancisco",
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
