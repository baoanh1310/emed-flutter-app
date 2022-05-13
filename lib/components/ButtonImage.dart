import 'package:flutter/material.dart';

class ButtonImage extends StatelessWidget {
  final Function onPressed;
  final String image;
  final Alignment alignmentIcon;

  const ButtonImage({Key key, this.onPressed, this.image, this.alignmentIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      disabledColor: Colors.transparent,
      onPressed: onPressed,
      child: Align(
        alignment: alignmentIcon != null ? alignmentIcon : Alignment.topLeft,
        child: Image.asset(
          image,
          width: 15,
          height: 15,
        ),
      ),
    );
  }
}
