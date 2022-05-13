import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            // SvgPicture.asset('assets/icons/app_icon.svg',
            //     color: Theme.of(context).primaryColor),
            Image.asset("assets/icons/app_icon.png", width: 20.w),
            SizedBox(
              width: 4,
            ),
            Text(
              'eMed',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontFamily: "Spartan",
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Color(0xFFECE9EF),
        ),
      ],
    );
  }
}
