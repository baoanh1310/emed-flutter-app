import 'package:flutter/material.dart';

@immutable
class CustomButton extends StatelessWidget {
  /// This is a builder class for a nice button
  ///
  /// Icon can be used to define the button design
  /// User can use Flutter built-in Icons or font-awesome flutter's Icon  final bool mini;
  final IconData icon;

  /// specify the color of the icon
  final Color iconColor;

  /// radius can be used to specify the button border radius
  final double radius;

  /// List of gradient colors to define the gradients

  /// This is the button's text
  final String text;

  /// This is the color of the button's text
  final Color textColor;

  /// User can define the background color of the button
  final Color background;

  /// User can define the width of the button
  final double width;

  /// Here user can define what to do when the button is clicked or pressed
  final Function onPressed;

  /// This is the elevation of the button
  final double elevation;

  /// This is the padding of the button
  final EdgeInsets padding;

  /// `mini` tag is used to switch from a full-width button to a small button
  final bool mini;

  /// This is the font size of the text
  final double fontSize;

  const CustomButton(
      {Key key,
      this.mini = false,
      this.radius = 4.0,
      this.elevation = 0,
      this.textColor = Colors.white,
      this.iconColor = Colors.white,
      this.width,
      this.padding = const EdgeInsets.all(5.0),
      @required this.onPressed,
      @required this.text,
      @required this.background,
      this.icon,
      this.fontSize = 23.0})
      : super(key: key);

  BoxDecoration get boxDecoration => BoxDecoration(
      borderRadius: BorderRadius.circular(radius), color: background);

  TextStyle get textStyle => TextStyle(
      fontFamily: 'SanFrancisco',
      color: textColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w500);

  Widget createContainer(BuildContext context) {
    return Container(
      padding: padding,
      decoration: boxDecoration,
      constraints:
          BoxConstraints(maxWidth: width ?? MediaQuery.of(context).size.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          // GradientIcon(
          //   Icons.photo_library,
          //   30.0,
          //   LinearGradient(
          //     colors: const <Color>[
          //       const Color.fromRGBO(254, 59, 92, 0.08),
          //       const Color.fromARGB(255, 248, 187, 169)
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      onPressed: onPressed,
      child: Material(
        borderRadius: BorderRadius.circular(radius),
        key: key,
        child: createContainer(context),
      ),
    );
  }
}
