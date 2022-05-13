import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final String initialText;
  final bool isFullRowTextField;
  final Function onChanged;
  final Function onTapped;
  final bool isEnabled;
  final TextInputType txtInputType;
  final String hintText;
  const CustomTextFormField({
    Key key,
    @required this.initialText,
    @required this.isFullRowTextField,
    this.onChanged,
    this.onTapped,
    this.hintText,
    @required this.isEnabled,
    this.txtInputType,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTapped,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: TextFormField(
          key: Key(widget.initialText), // <- Magic!
          enabled: widget.isEnabled,
          initialValue: widget.initialText,
          decoration: new InputDecoration(
            isDense: true,
            hintText: widget.hintText,
            border: OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                borderRadius: BorderRadius.circular(5)),
            contentPadding: widget.isFullRowTextField
                ? EdgeInsets.fromLTRB(16.w, 5.h, 16.w, 5.h)
                : EdgeInsets.all(5),
          ),

          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: "SanFrancisco",
            fontSize: 12.sp,
          ),
          keyboardType: widget.txtInputType,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
