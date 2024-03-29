import 'package:flutter/material.dart';

import './constant.dart';

ThemeData appThemeData() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "SanFrancisco",
    primaryColor: kPrimaryColor,
    primaryColorLight: kPrimaryLightColor,
    primaryColorDark: kPrimaryDarkColor,
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
    enabledBorder: kOutlineInputEnableBorder,
    focusedBorder: kOutlineInputFocusedBorder,
    border: kOutlineInputEnableBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: kTextColor, fontSize: 12),
    bodyText2: TextStyle(color: kTextColor, fontSize: 12),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: Colors.white,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    ),
  );
}
