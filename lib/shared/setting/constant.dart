import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kPrimaryColor = Color(0xFF1AADBB);
const kPrimaryLightColor = Color(0xFF63DFED);
const kPrimaryDarkColor = Color(0xFF007D8D);
const kBorderPrimaryColor = Color.fromRGBO(153, 216, 222, 1);
const kPrimaryBackgroundColor = Color.fromRGBO(239, 249, 250, 1);
const kPrimaryExtraLightColor = Color.fromRGBO(26, 173, 187, 0.05);
const kAppBackgroundColor = Color(0xFFFFFFFF);
const kTextColor = Color(0xFF040D3A);
const kInputBorderEnableColor = Color(0xFFDADADA);
const kTextNoteColor = Color(0xFF83889F);
const kSeparator = Color.fromRGBO(201, 197, 195, 1);
const kTextCalendarColor = Color(0xFF495699);
const kCompleteColor = Color(0xFF07AF73);
const kAnimationDuration = Duration(milliseconds: 200);
const kSearchBorder = Color(0xFFECEBED);
const kCalendarBackgroundColor = Color.fromRGBO(243, 243, 243, 1);
const kDrugDetailBackgroundColor = Color.fromRGBO(243, 246, 200, 1);
const kDrugTextColor = Color.fromRGBO(131, 136, 159, 1);
const kHightLightColor = Color.fromRGBO(255, 18, 0, 1);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final kSearchInputDecoration = InputDecoration(
  prefixIcon: Icon(Icons.search),
  hintMaxLines: 1,
  hintStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'SanFrancisco',
    fontSize: 12.sp,
  ),
  contentPadding: EdgeInsets.only(right: 38),
  enabledBorder: kSearchInputBorder,
  focusedBorder: kSearchInputBorder,
);

final kPillResultTextDecoration = InputDecoration(
  // hintMaxLines: 1,
  // hintStyle: TextStyle(
  //   fontWeight: FontWeight.w400,
  //   fontFamily: 'SanFrancisco',
  //   fontSize: 12.sp,
  // ),
  contentPadding: EdgeInsets.only(right: 30),
  // enabledBorder: OutlineInputBorder(
  //   borderRadius: BorderRadius.circular(5),
  //   borderSide: BorderSide(
  //     color: kSearchBorder,
  //   ),
  //   gapPadding: 100,
  // ),
  // focusedBorder: OutlineInputBorder(
  //   borderRadius: BorderRadius.circular(5),
  //   borderSide: BorderSide(
  //     color: kSearchBorder,
  //   ),
  //   gapPadding: 100,
  // ),
);

final kSearchInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(28),
  borderSide: BorderSide(
    color: kSearchBorder,
  ),
  gapPadding: 100,
);

final kOutlineInputEnableBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(color: kInputBorderEnableColor),
  gapPadding: 10,
);

final kOutlineInputFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  // borderSide: BorderSide(color: kTextColor),
  gapPadding: 10,
);

const CONFIG_BASE_URL = 'https://base-url.com';

const FEEDBACK_URL = 'https://forms.gle/4y1d4yHuvA9Ej7xK8';
