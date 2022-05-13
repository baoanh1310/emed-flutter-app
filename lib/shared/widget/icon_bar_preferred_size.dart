import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconBarPrefferSize extends PreferredSize {
  final double height;

  IconBarPrefferSize({
    this.height,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            SvgPicture.asset('assets/icons/app_icon.svg',
                color: Theme.of(context).primaryColor),
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
