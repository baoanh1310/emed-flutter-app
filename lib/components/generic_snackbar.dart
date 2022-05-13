// truyen code vao snack bar va tra ve string error tuong ung voi ma code
import 'package:emed/shared/setting/constant.dart';
import 'package:flutter/material.dart';

class GlobalSnackBar extends StatelessWidget {
  final String message;
  final BuildContext buildContext;
  const GlobalSnackBar({
    @required this.message,
    @required this.buildContext,
  });

  Widget build(BuildContext context) {
    return SnackBar(
      elevation: 0.0,
      //behavior: SnackBarBehavior.floating,
      content: Text(message,
          style: Theme.of(buildContext)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.white)),
      // duration: new Duration(seconds: 5000000),
      backgroundColor: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      duration: Duration(milliseconds: 500),
    );
  }

  static show(
    GlobalKey<ScaffoldState> key,
    BuildContext context,
    String message,
  ) {
    key.currentState.showSnackBar(
      SnackBar(
        elevation: 0.0,
        //behavior: SnackBarBehavior.floating,
        content: Text(message,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white)),
        backgroundColor: kPrimaryColor,
        duration: Duration(milliseconds: 650),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        // ),
        //backgroundColor: Colors.redAccent,
        // action: SnackBarAction(
        //   textColor: Color(0xFFFAF2FB),
        //   label: 'OK',
        //   onPressed: () {},
        // ),
      ),
    );
  }
}
