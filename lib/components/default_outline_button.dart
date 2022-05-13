import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultOutlineButton extends StatelessWidget {
  const DefaultOutlineButton({
    Key key,
    this.text,
    this.borderColor,
    this.textColor,
    this.press,
  }) : super(key: key);
  final String text;
  final Color borderColor;
  final Color textColor;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        minWidth: 98,
        height: 34.0,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(7.w)),
        onPressed: press,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 12.sp,
            ),
          ),
        ));
  }
}
