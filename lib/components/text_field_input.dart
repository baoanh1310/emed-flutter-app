import 'package:emed/shared/setting/constant.dart';
import 'package:flutter/material.dart';
import 'package:emed/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final String errorText;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  const RoundedInputField(
      {Key key,
      this.hintText,
      this.icon = Icons.person,
      this.onChanged,
      this.label,
      this.errorText,
      this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Color.fromRGBO(12, 24, 39, 1),
              fontWeight: FontWeight.w500,
              fontFamily: "SanFrancisco",
              fontSize: 14.0),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        TextField(
          autocorrect: false,
          enableSuggestions: false,
          obscureText: (obscureText != null) ? obscureText : false,
          onChanged: onChanged,
          // cursorColor: kPrimaryColor,
          decoration: InputDecoration(
            // enabledBorder: kOutlineInputBorder.copyWith(
            //   borderSide: BorderSide(color: kInputBorderColor),
            // ),
            hintText: hintText,
            errorText:
                (errorText != null && errorText != "") ? errorText : null,
          ),
        ),
      ],
    ));
  }
}
