import 'package:flutter/material.dart';
import 'package:emed/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // width: size.width * 0.8,
      // height: size.height * 0.06,
      decoration: BoxDecoration(
          // color: kPrimaryLightColor,
          // borderRadius: BorderRadius.circular(5),
          ),
      child: child,
    );
  }
}
