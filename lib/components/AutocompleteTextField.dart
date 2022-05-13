import 'package:emed/shared/setting/constant.dart';
import 'package:flutter/material.dart';

class AutocompleteField extends StatefulWidget {
  final bool prefixIcon;
  final double radius;
  final String hintText;

  AutocompleteField({Key key, this.prefixIcon, this.radius, this.hintText})
      : super(key: key);

  @override
  _AutocompleteFieldState createState() => _AutocompleteFieldState();
}

class _AutocompleteFieldState extends State<AutocompleteField> {
  final TextEditingController _controller = TextEditingController();
  bool showClearIcon = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Stack(
        children: [
          TextFormField(
            decoration: kSearchInputDecoration.copyWith(
                hintText: widget.hintText != null ? widget.hintText : ""),
            // prefixIcon: widget.prefixIcon == true
            //     ? Icon(Icons.search)
            //     : Icon(Icons.search),
            // enabledBorder: widget.radius != null
            //     ? kSearchInputBorder
            //     : OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(widget.radius),
            //         borderSide: BorderSide(
            //           color: kSearchBorder,
            //         ),
            //         gapPadding: 100,
            // )),
            controller: _controller,
            onChanged: (value) {
              if ((value.isEmpty && showClearIcon) ||
                  (value.isNotEmpty && !showClearIcon)) {
                setState(() {
                  showClearIcon = !showClearIcon;
                });
              }
            },
          ),
          if (showClearIcon)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _controller.text = '';
                  setState(() {
                    showClearIcon = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
