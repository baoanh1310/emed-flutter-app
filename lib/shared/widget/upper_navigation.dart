import 'package:flutter/material.dart';
import 'package:emed/components/ButtonImage.dart';
import 'package:emed/shared/setting/navigation_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpperNavigation extends StatelessWidget {
  final String _header;
  UpperNavigation(this._header);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonImage(
          image: "assets/icons/arrow_back.png",
          onPressed: () => NavigationService().pop(),
          // NavigationService().pop(),
        ),
        SizedBox(
          width: 60.w,
        ),
        Text(_header,
            // textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(12, 24, 39, 1),
                fontWeight: FontWeight.w500,
                fontFamily: "SanFrancisco",
                fontSize: 18.sp)),
      ],
    );
  }
}
